#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
    NSString *appPath = [[[[[[NSBundle mainBundle] bundlePath]
        stringByDeletingLastPathComponent]
            stringByDeletingLastPathComponent]
                stringByDeletingLastPathComponent]
                    stringByDeletingLastPathComponent]; 

    [[NSWorkspace sharedWorkspace] launchApplication:appPath];

    [NSApp terminate:nil];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

@end
