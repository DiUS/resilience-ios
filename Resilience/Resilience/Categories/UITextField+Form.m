
#import "UITextField+Form.h"
#import "UITextField+Resilience.h"
#import "UIColor+Resilience.h"

@implementation UITextField (Form)

+ (UITextField *)formTextField:(NSString *)placeholder {
  return [UITextField formTextField:placeholder keyboard:UIKeyboardTypeAlphabet];
}

+ (UITextField *)formTextField:(NSString *)placeholder keyboard:(UIKeyboardType)keyboard {
  UITextField *textField = [UITextField styledTextField];
  textField.placeholder = placeholder;
  textField.borderStyle = UITextBorderStyleNone;
  textField.textColor = [UIColor lightGreyTextColor];
  textField.font = [UIFont systemFontOfSize:16.0];
  textField.backgroundColor = [UIColor clearColor];
  textField.keyboardType = keyboard;
  textField.returnKeyType = UIReturnKeyDone;
  textField.clearButtonMode = UITextFieldViewModeWhileEditing;  // has a clear 'x' button to the right
  textField.translatesAutoresizingMaskIntoConstraints = NO;
  return textField;
}

+ (UITextField *)multilineTextField:(NSString *)placeholder {
  UITextField *textField = [UITextField styledTextField];
  textField.placeholder = placeholder;
  textField.borderStyle = UITextBorderStyleBezel;
  textField.textColor = [UIColor defaultTextColor];
  textField.font = [UIFont systemFontOfSize:16.0];
  textField.backgroundColor = [UIColor whiteColor];
  textField.keyboardType = UIKeyboardTypeAlphabet;
  textField.returnKeyType = UIReturnKeyDone;
  textField.clearButtonMode = UITextFieldViewModeWhileEditing;  // has a clear 'x' button to the right
  textField.translatesAutoresizingMaskIntoConstraints = NO;
  return textField;
}

+ (UITextField *)emailFormTextField:(NSString *)placeholder {
  return [UITextField formTextField:placeholder keyboard:UIKeyboardTypeEmailAddress];
}

+ (UITextField *)numberFormTextField:(NSString *)placeholder {
  return [UITextField formTextField:placeholder keyboard:UIKeyboardTypePhonePad];
}


@end