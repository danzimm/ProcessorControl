//
//  Helpers.c
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/21/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include "Helpers.h"

#define TYPECASE(t, a) case CPU_TYPE_##t: a = # t;
#define SUBTYPECASE(t, a) case CPU_SUBTYPE_##t: a = # t; break;

char *lowercase_copy(char *str) {
  if (!str)
    return NULL;
  char *ret = (char *)malloc(strlen(str)+1);
  size_t i;
  for (i = 0; i < strlen(str); i++) {
    ret[i] = tolower(str[i]);
  }
  return ret;
}

char *string_for_processor(cpu_type_t type, cpu_subtype_t subtype) {
  char *tstr = NULL, *ststr = NULL;
  switch (type) {
      TYPECASE(VAX, tstr) {
        switch (subtype) {
            SUBTYPECASE(VAX780, ststr);
            SUBTYPECASE(VAX785, ststr);
            SUBTYPECASE(VAX750, ststr);
            SUBTYPECASE(VAX730, ststr);
            SUBTYPECASE(UVAXI, ststr);
            SUBTYPECASE(UVAXII, ststr);
            SUBTYPECASE(VAX8200, ststr);
            SUBTYPECASE(VAX8500, ststr);
            SUBTYPECASE(VAX8600, ststr);
            SUBTYPECASE(VAX8650, ststr);
            SUBTYPECASE(VAX8800, ststr);
            SUBTYPECASE(UVAXIII, ststr);
          default:
            ststr = "VAX";
            break;
        }
      } break;
      TYPECASE(MC680x0, tstr) {
        switch (subtype) {
            SUBTYPECASE(MC68030, ststr);
            SUBTYPECASE(MC68040, ststr);
            SUBTYPECASE(MC68030_ONLY, ststr);
          default:
            ststr = "MC680x0";
            break;
        }
      } break;
      TYPECASE(X86, tstr) {
        switch (subtype) {
            SUBTYPECASE(386, ststr);
            SUBTYPECASE(486, ststr);
            SUBTYPECASE(486SX, ststr);
            SUBTYPECASE(PENT, ststr);
            SUBTYPECASE(PENTPRO, ststr);
            SUBTYPECASE(PENTII_M3, ststr);
            SUBTYPECASE(PENTII_M5, ststr);
            SUBTYPECASE(CELERON, ststr);
            SUBTYPECASE(CELERON_MOBILE, ststr);
            SUBTYPECASE(PENTIUM_3, ststr);
            SUBTYPECASE(PENTIUM_3_M, ststr);
            SUBTYPECASE(PENTIUM_3_XEON, ststr);
            SUBTYPECASE(PENTIUM_M, ststr);
            SUBTYPECASE(PENTIUM_4, ststr);
            SUBTYPECASE(PENTIUM_4_M, ststr);
            SUBTYPECASE(ITANIUM, ststr);
            SUBTYPECASE(ITANIUM_2, ststr);
            SUBTYPECASE(XEON, ststr);
            SUBTYPECASE(XEON_MP, ststr);
          default:
            ststr = "I386";
            break;
        }
      } break;
      TYPECASE(X86_64, tstr) {
        switch (subtype) {
            SUBTYPECASE(X86_64_ALL, ststr);
            SUBTYPECASE(X86_ARCH1, ststr);
          default:
            ststr = "X86";
            break;
        }
      } break;
      TYPECASE(MC98000, tstr) {
        switch (subtype) {
            SUBTYPECASE(MC98000_ALL, ststr);
            SUBTYPECASE(MC98601, ststr);
          default:
            ststr = "MC98000";
            break;
        }
      } break;
      TYPECASE(HPPA, tstr) {
        switch (subtype) {
            SUBTYPECASE(HPPA_7100, ststr);
            SUBTYPECASE(HPPA_7100LC, ststr);
          default:
            ststr = "HPPA";
            break;
        }
      } break;
      TYPECASE(ARM, tstr) {
        switch (subtype) {
            SUBTYPECASE(ARM_ALL, ststr);
            SUBTYPECASE(ARM_V4T, ststr);
            SUBTYPECASE(ARM_V6, ststr);
            SUBTYPECASE(ARM_V5TEJ, ststr);
            SUBTYPECASE(ARM_XSCALE, ststr);
            SUBTYPECASE(ARM_V7, ststr);
            SUBTYPECASE(ARM_V7F, ststr);
            SUBTYPECASE(ARM_V7S, ststr);
            SUBTYPECASE(ARM_V7K, ststr);
            SUBTYPECASE(ARM_V6M, ststr);
            SUBTYPECASE(ARM_V7M, ststr);
            SUBTYPECASE(ARM_V7EM, ststr);
          default:
            ststr = "ARM";
            break;
        }
      } break;
      TYPECASE(MC88000, tstr) {
        switch (subtype) {
            SUBTYPECASE(MC88000_ALL, ststr);
            SUBTYPECASE(MC88100, ststr);
            SUBTYPECASE(MC88110, ststr);
          default:
            ststr = "MC88000";
            break;
        }
      } break;
      TYPECASE(SPARC, tstr) {
        ststr = "SPARC";
      } break;
      TYPECASE(I860, tstr) {
        switch (subtype) {
            SUBTYPECASE(I860_ALL, ststr);
            SUBTYPECASE(I860_860, ststr);
          default:
            ststr = "I860";
            break;
        }
      } break;
      TYPECASE(POWERPC, tstr)
      TYPECASE(POWERPC64, tstr) {
        switch (subtype) {
            SUBTYPECASE(POWERPC_601, ststr);
            SUBTYPECASE(POWERPC_602, ststr);
            SUBTYPECASE(POWERPC_603, ststr);
            SUBTYPECASE(POWERPC_603e, ststr);
            SUBTYPECASE(POWERPC_603ev, ststr);
            SUBTYPECASE(POWERPC_604, ststr);
            SUBTYPECASE(POWERPC_604e, ststr);
            SUBTYPECASE(POWERPC_620, ststr);
            SUBTYPECASE(POWERPC_750, ststr);
            SUBTYPECASE(POWERPC_7400, ststr);
            SUBTYPECASE(POWERPC_7450, ststr);
            SUBTYPECASE(POWERPC_970, ststr);
          default:
            ststr = "POWERPC";
            break;
        }
      } break;
    default:
      tstr = "UNKNOWN";
      break;
  }
  char *ret = NULL;
  char *lc = lowercase_copy(tstr);
  asprintf(&ret, "%s:%s", lc, ststr);
  free(lc);
  return ret;
}

kern_return_t load_info(processor_t processor, struct processor_cpu_load_info *info) {
  kern_return_t kr = KERN_SUCCESS;
  mach_msg_type_number_t info_count = PROCESSOR_CPU_LOAD_INFO_COUNT;
  host_t host = MACH_PORT_NULL;
  bzero(info, sizeof(struct processor_basic_info));
  kr = processor_info(processor, PROCESSOR_CPU_LOAD_INFO, &host, (processor_info_t)info, &info_count);
  return kr;
}

// TODO: some sort of cache is needed
kern_return_t quick_info(processor_t processor, struct processor_basic_info *info) {
  kern_return_t kr = KERN_SUCCESS;
  mach_msg_type_number_t info_count = PROCESSOR_BASIC_INFO_COUNT;
  host_t host = MACH_PORT_NULL;
  bzero(info, sizeof(struct processor_basic_info));
  kr = processor_info(processor, PROCESSOR_BASIC_INFO, &host, (processor_info_t)info, &info_count);
  return kr;
}
