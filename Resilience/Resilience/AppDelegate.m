#import "AppDelegate.h"
#import "IssueMapViewController.h"
#import "IssueListViewController.h"
#import "RootViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  RootViewController *rootViewController = [[RootViewController alloc] init];
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];

  UIImage *navBarImage = [UIImage imageNamed:@"TitleBar"];
  [[UINavigationBar appearance] setBackgroundImage:[navBarImage resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)] forBarMetrics:UIBarMetricsDefault];

  self.window.rootViewController = navigationController;

  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
