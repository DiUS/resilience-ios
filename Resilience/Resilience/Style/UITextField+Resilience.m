#import <sys/ucred.h>
#import <QuartzCore/QuartzCore.h>
#import "UITextField+Resilience.h"

@implementation UITextField (Resilience)

+ (UITextField *)styledTextField {
  UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
  textField.backgroundColor = [UIColor clearColor];
  textField.borderStyle = UITextBorderStyleRoundedRect;
  return textField;
}

@end