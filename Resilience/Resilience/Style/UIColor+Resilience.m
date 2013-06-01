
#import "UIColor+Resilience.h"


@implementation UIColor (Resilience)


+ (UIColor *)titleTextColor {
  return [UIColor colorWithRed:(59.f/255.f) green:(59.f/255.f) blue:(59.f/255.f) alpha:1];
}

+ (UIColor *)defaultTextColor {
  return [UIColor colorWithRed:(89.f/255.f) green:(89.f/255.f) blue:(89.f/255.f) alpha:1];
}

+ (UIColor *)defaultBackgroundColor
{
    return [UIColor colorWithRed:(239.0f/255.0f) green:(239.0f/255.0f) blue:(239.0f/255.0f) alpha:1];
}

+ (UIColor *)lightGreyTextColor
{
  return [UIColor colorWithRed:(59.0f/255.0f) green:(59.0f/255.0f) blue:(59.0f/255.0f) alpha:1];

}

@end