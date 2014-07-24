//
//  Helpers.h
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/21/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#include <mach/mach.h>
#include <stdlib.h>

#ifndef _Helpers_h
#define _Helpers_h

kern_return_t quick_info(processor_t processor, struct processor_basic_info *info);
kern_return_t load_info(processor_t processor, struct processor_cpu_load_info *info);
char *string_for_processor(cpu_type_t type, cpu_subtype_t subtype);
char *lowercase_copy(char *str);

#endif
