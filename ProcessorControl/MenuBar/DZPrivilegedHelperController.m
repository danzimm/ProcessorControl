//
//  DZPrivilegedHelperController.m
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/29/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

@import ServiceManagement;
@import Security.Authorization;

#import "DZPrivilegedHelperController.h"

@implementation DZPrivilegedHelperController

+ (NSError *)installHelperWithLabel:(NSString *)label {
  NSLog(@"Installing helper!");
  
  NSError *error = nil;
  AuthorizationRef authRef;
  
  OSStatus status = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &authRef);
  if (status != errAuthorizationSuccess) {
    /* AuthorizationCreate really shouldn't fail. */
    assert(NO);
    authRef = NULL;
  }
  
  if (![self blessHelperWithLabel:label authorization:authRef error:&error]) {
    return error;
	} else {
    return nil;
	}
}

+ (BOOL)blessHelperWithLabel:(NSString *)label authorization:(AuthorizationRef)authRef error:(NSError **)errorPtr {
	BOOL result = NO;
  NSError *error = nil;
  
	AuthorizationItem authItem		= { kSMRightBlessPrivilegedHelper, 0, NULL, 0 };
	AuthorizationRights authRights	= { 1, &authItem };
	AuthorizationFlags flags		=	kAuthorizationFlagDefaults				|
  kAuthorizationFlagInteractionAllowed	|
  kAuthorizationFlagPreAuthorize			|
  kAuthorizationFlagExtendRights;
  
	/* Obtain the right to install our privileged helper tool (kSMRightBlessPrivilegedHelper). */
	OSStatus status = AuthorizationCopyRights(authRef, &authRights, kAuthorizationEmptyEnvironment, flags, NULL);
	if (status != errAuthorizationSuccess) {
		error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
	} else {
    CFErrorRef  cfError;
    
		/* This does all the work of verifying the helper tool against the application
		 * and vice-versa. Once verification has passed, the embedded launchd.plist
		 * is extracted and placed in /Library/LaunchDaemons and then loaded. The
		 * executable is placed in /Library/PrivilegedHelperTools.
		 */
		result = (BOOL) SMJobBless(kSMDomainSystemLaunchd, (__bridge CFStringRef)label, authRef, &cfError);
    if (!result) {
      error = CFBridgingRelease(cfError);
    }
	}
  if ( ! result && (errorPtr != NULL) ) {
    assert(error != nil);
    *errorPtr = error;
  }
	
	return result;
}

@end
