
#import "UIImage+Tileable.h"

@implementation UIImage (Tileable)

-(UIImage*) imageResizingModeTile
{
  float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];

  if( iOSVersion >= 6.0f )
  {
    return [self resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
  }
  else
  {
    return [self resizableImageWithCapInsets:UIEdgeInsetsZero];
  }
}
@end