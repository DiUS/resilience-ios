
#import <Foundation/Foundation.h>

@interface UITextField (Form)
+ (UITextField *)formTextField:(NSString *)placeholder;

+ (UITextField *)formTextField:(NSString *)placeholder keyboard:(UIKeyboardType)keyboard;

+ (UITextField *)multilineTextField:(NSString *)placeholder;

+ (UITextField *)emailFormTextField:(NSString *)placeholder;

+ (UITextField *)numberFormTextField:(NSString *)placeholder;
@end