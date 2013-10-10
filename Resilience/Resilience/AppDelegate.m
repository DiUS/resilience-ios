#import "AppDelegate.h"
#import "RootViewController.h"
#import "AFHTTPRequestOperationLogger.h"
#import "UIColor+Resilience.h"
#import "ResilientUploader.h"
#import "GAI.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#if DEBUG
  [[AFHTTPRequestOperationLogger sharedLogger] startLogging];
#endif
  [GAI sharedInstance].trackUncaughtExceptions = YES;
  [[GAI sharedInstance] trackerWithTrackingId:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"GATrackerId"]];

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  RootViewController *rootViewController = [[RootViewController alloc] init];

  UIImage *navBarImage = [UIImage imageNamed:@"Assets/TitleBar"];
  [[UINavigationBar appearance] setBackgroundImage:[navBarImage resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)] forBarMetrics:UIBarMetricsDefault];
  [[UIToolbar appearance] setBackgroundImage:[navBarImage resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
  [[UINavigationBar appearance] setTintColor:[UIColor lightGrayColor]];

  NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
  [titleBarAttributes setValue:[UIColor darkGreyTextColor] forKey:UITextAttributeTextColor];
  [titleBarAttributes setValue:[UIColor clearColor] forKey:UITextAttributeTextShadowColor];
  [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];

  self.window.rootViewController = rootViewController;

  [[ResilientUploader sharedUploader] uploadQueuedIncident];

  [self.window makeKeyAndVisible];

  return YES;
}

@end
