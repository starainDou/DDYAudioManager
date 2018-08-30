//      _____                 &&&&_) )
//      \/,---<                &&&&&&\ \
//      ( )c~c~~@~@            )- - &&\ \
//      C   >/                \<   |&/
//      \_O/ - 哇塞          _`*-'_/ /
//      ,- >o<-.              / ____ _/
//      /   \/   \            / /\  _)_)
//      / /|  | |\ \          / /  )   |
//      \ \|  | |/ /          \ \ /    |
//      \_\  | |_/            \ \_    |
//      /_/`___|_\            /_/\____|
//      |  | |                  \  \|
//      |  | |                   `. )
//      |  | |                   / /
//      |__|_|_                 /_/|
//      (____)_)                |\_\_
#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
    _window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    [_window makeKeyAndVisible];
    return YES;
}

@end
