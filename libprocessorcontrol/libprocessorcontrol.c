#include <stdio.h>
#include <stdlib.h>
#include <mach/mach.h>
#include <servers/bootstrap.h>

#include "processorcontrol.h"

#define ENSURE_SUCCESS(c) \
    if ((ret = c) != KERN_SUCCESS) { \
      mach_error( # c , ret); \
    }

mach_port_t processorcontrol_port;
kern_return_t processorcontrol_error;

__attribute__((constructor))
static int lib_processorcontrol_init(void) {
  kern_return_t ret = KERN_SUCCESS;
  ENSURE_SUCCESS(bootstrap_look_up(bootstrap_port, "proccontrol_server", &processorcontrol_port));
  processorcontrol_error = ret;
  return 0;
}

