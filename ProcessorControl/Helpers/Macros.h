//
//  Macros.h
//
//
//  Created by Dan Zimmerman on 5/6/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#ifndef _DanZimm_Macros_h
#define _DanZimm_Macros_h

#define USET(u,l, t, pre, after) \
- (void)set ## u:(t)l { \
  { pre; } \
  _ ## l = l; \
  { after; } \
}

#endif
