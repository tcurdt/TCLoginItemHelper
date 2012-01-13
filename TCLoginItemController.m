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
//    NSLog(@"%@ = %d", bundle.bundleIdentifier, enabled);

    if (LSRegisterURL((CFURLRef)bundle.bundleURL, TRUE) != noErr) {
        NSLog(@"LSRegisterURL failed!");
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
