
#import "UIDevice+iOS7.h"

@implementation UIDevice (iOS7)

+(BOOL)iOS7 {
  return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.;
}

@end