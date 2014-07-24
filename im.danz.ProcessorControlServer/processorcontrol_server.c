#include <stdio.h>
#include <stdlib.h>
#include <syslog.h>
#include <mach/mach.h>
#include <unistd.h>
#include <errno.h>
#include <servers/bootstrap.h>
#include <sys/param.h>
#include <pthread.h>
#include "processorcontrolServer.h"

extern boolean_t processorcontrol_server(
		mach_msg_header_t *InHeadP,
		mach_msg_header_t *OutHeadP);

#ifdef DAEMON
#define log(s, a...) syslog(s, a)
#else
#define log(s, a...) \
  if (s == LOG_ERR || s == LOG_CRIT || s == LOG_ALERT || s == LOG_EMERG) { \
    fprintf(stderr, a); \
  } else { \
    printf(a); \
  }
#endif

#define ENSURE_SUCCESS(c) \
    if ((ret = c) != KERN_SUCCESS) { \
      log(LOG_ERR, "%s: %s (%d)", # c, mach_error_string(ret), ret); \
      return ret; \
    }

kern_return_t serv_proccontrol_processors(mach_port_t proccontrol_port, processor_array_t *out_processor_list, mach_msg_type_number_t *out_processor_listCnt) {
  return host_processors(mach_host_self(), out_processor_list, out_processor_listCnt);
}

kern_return_t serv_proccontrol_version(mach_port_t proccontrol_port, uint64_t *version) {
  *version = 1;
  return KERN_SUCCESS;
}

void *uninstall_routine(void *a) {
  int pid = fork();
  if (pid == 0) {
    sleep(2);
    log(LOG_NOTICE, "Uninstalling daemon");
    system("sudo mv /Library/LaunchDaemons/im.danz.ProcessorControlServer.plist /tmp/im.danz.ProcessorControlServer.plist");
    system("sudo rm /Library/PrivilegedHelperTools/im.danz.ProcessorControlServer");
    system("sudo launchctl unload /tmp/im.danz.ProcessorControlServer.plist");
    exit(0);
  }
  return NULL;
}

kern_return_t serv_proccontrol_uninstall(mach_port_t proccontrol_port) {
  pthread_t thread;
  pthread_create(&thread, NULL, uninstall_routine, NULL);
  pthread_detach(thread);
  return KERN_SUCCESS;
}

int main(int argc, const char *argv[]) {
  mach_port_t server_port = MACH_PORT_NULL;
  kern_return_t ret = KERN_SUCCESS;
  log(LOG_NOTICE, "Launching proccontrol server!\n");
  if ((ret = seteuid(0)) != 0) {
    log(LOG_ERR, "Failed to start (%s), need uid of 0!\n", strerror(errno));
    return -1;
  }
  ENSURE_SUCCESS(bootstrap_check_in(bootstrap_port, (char *)"proccontrol_server", &server_port));
  log(LOG_NOTICE, "Checked into the bootstrap server!\n");
  while (1) {
    if ((ret = mach_msg_server(processorcontrol_server, MAX(sizeof(__Request__proccontrol_processors_t), sizeof(__Reply__proccontrol_processors_t)), server_port, 0)) != KERN_SUCCESS) {
      log(LOG_ERR, "mach_msg_server: %s (%d)\n", mach_error_string(ret), ret);
    }
  }
}
