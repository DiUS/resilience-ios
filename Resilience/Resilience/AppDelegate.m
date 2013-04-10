#import "AppDelegate.h"
#import "RootViewController.h"
#import "DCIntrospect.h"
#import "AFHTTPRequestOperationLogger.h"
#import "UIColor+Resilience.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [[AFHTTPRequestOperationLogger sharedLogger] startLogging];

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  RootViewController *rootViewController = [[RootViewController alloc] init];
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];

  UIImage *navBarImage = [UIImage imageNamed:@"Assets/TitleBar"];
  [[UINavigationBar appearance] setBackgroundImage:[navBarImage resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)] forBarMetrics:UIBarMetricsDefault];
  [[UIToolbar appearance] setBackgroundImage:[navBarImage resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];

  NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
  [titleBarAttributes setValue:[UIColor lightGreyTextColor] forKey:UITextAttributeTextColor];
  [titleBarAttributes setValue:[UIColor clearColor] forKey:UITextAttributeTextShadowColor];
  [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];

  self.window.rootViewController = navigationController;

  [self.window makeKeyAndVisible];

#if TARGET_IPHONE_SIMULATOR
  [[DCIntrospect sharedIntrospector] start];
#endif
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
