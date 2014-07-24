//
//  PCStartupHelper.m
//  processorcontrol
//
//  Created by Dan Zimmerman on 4/21/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#import "DZStartupHelper.h"

@implementation DZStartupHelper

+ (BOOL)startUp {
    BOOL retval = NO;
    UInt32 seedValue, i;
    CFURLRef url;
    CFStringRef lastComp;
    LSSharedFileListRef startupItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (startupItems) {
        CFArrayRef fileList = LSSharedFileListCopySnapshot(startupItems, &seedValue);
        if (fileList) {
            for (i = 0; i < CFArrayGetCount(fileList) && !retval; i++) {
                if ((url = LSSharedFileListItemCopyResolvedURL((LSSharedFileListItemRef)CFArrayGetValueAtIndex(fileList, i), 0, NULL)) != NULL) {
                      lastComp = CFURLCopyLastPathComponent(url);
                      if (lastComp) {
                          if (CFStringCompare(lastComp, (__bridge CFStringRef)[[[NSBundle mainBundle] bundleURL] lastPathComponent], kCFCompareCaseInsensitive) == kCFCompareEqualTo) {
                              retval = YES;
                          }
                          CFRelease(lastComp);
                      }
                      CFRelease(url);
                }
            }
            CFRelease(fileList);
        }
        CFRelease(startupItems);
    }
    return retval;
}

+ (void)setStartUp:(BOOL)startUp {
    LSSharedFileListItemRef startUpItem = NULL;
    UInt32 seedValue, i;
    CFURLRef url;
    CFStringRef lastComp;
    LSSharedFileListRef startUpItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (startUpItems) {
        CFArrayRef fileList = LSSharedFileListCopySnapshot(startUpItems, &seedValue);
        if (fileList) {
            for (i = 0; i < CFArrayGetCount(fileList) && startUpItem == NULL; i++) {
                if ((url = LSSharedFileListItemCopyResolvedURL((LSSharedFileListItemRef)CFArrayGetValueAtIndex(fileList, i), 0, NULL)) != NULL) {
                      lastComp = CFURLCopyLastPathComponent(url);
                      if (lastComp) {
                          if (CFStringCompare(lastComp, (__bridge CFStringRef)[[[NSBundle mainBundle] bundleURL] lastPathComponent], kCFCompareCaseInsensitive) == kCFCompareEqualTo) {
                              startUpItem = (LSSharedFileListItemRef)CFArrayGetValueAtIndex(fileList, i);
                          }
                          CFRelease(lastComp);
                      }
                      CFRelease(url);
                }
            }
        }
        
        if (startUp && !startUpItem) {
            LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(startUpItems, kLSSharedFileListItemBeforeFirst, NULL, NULL, (__bridge CFURLRef)([[NSBundle mainBundle] bundleURL]), NULL, NULL);
            if (item)
                CFRelease(item);
        } else if (!startUp && startUpItem) {
            LSSharedFileListItemRemove(startUpItems, startUpItem);
        }
        
        if (fileList)
            CFRelease(fileList);
        CFRelease(startUpItems);
    }
}

@end
