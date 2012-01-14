/*
 * Copyright 2011-2012, Torsten Curdt
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#import "TCLoginItemController.h"
#import <ServiceManagement/ServiceManagement.h>

@implementation TCLoginItemController

- (NSBundle *) helperBundle
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *path = [[mainBundle bundlePath] stringByAppendingPathComponent: @"Contents/Library/LoginItems/LoginItemHelper.app"];
    return [NSBundle bundleWithPath:path];
}


- (void) setLaunchAtLoginBundle:(NSBundle*)bundle enabled:(BOOL)enabled
{
    NSLog(@"%@ = %d", bundle.bundleIdentifier, enabled);

    OSStatus error = LSRegisterURL((CFURLRef)bundle.bundleURL, TRUE);
    if (error != noErr) {
        NSLog(@"LSRegisterURL failed to register %@ [%d]", bundle.bundleURL, error);
    }

    if (!SMLoginItemSetEnabled((CFStringRef) bundle.bundleIdentifier, enabled)) {
        NSLog(@"SMLoginItemSetEnabled failed!");
    }

// Seems like this is now required
//    if (!enabled) {
//        CFErrorRef error = NULL;
//        if (!SMJobRemove(kSMDomainUserLaunchd, (CFStringRef) bundle.bundleIdentifier, NULL, true, &error)) {
//            NSLog(@"SMJobRemove failed: %@", (NSError*)error);
//        }
//    }
}

- (BOOL) launchAtLoginBundle:(NSBundle*)bundle
{
    CFDictionaryRef dict = SMJobCopyDictionary(kSMDomainUserLaunchd, (CFStringRef) bundle.bundleIdentifier);
    if (dict == NULL) {
        return NO;
    }
    CFRelease(dict);
    return YES;
}

- (void) setLaunchAtLogin:(BOOL)enabled
{
    [self willChangeValueForKey:@"startAtLogin"];
    [self setLaunchAtLoginBundle:[self helperBundle] enabled:enabled];
    [self didChangeValueForKey:@"startAtLogin"];
}

- (BOOL) launchAtLogin
{
    return [self launchAtLoginBundle:[self helperBundle]];
}



@end
