
#import <Foundation/Foundation.h>


#define kProfileFirstNameKey       @"firstName"
#define kProfileLastNameKey        @"lastName"
#define kProfileEmailKey           @"email"
#define kProfilePhoneNameKey      @"mobile"

@interface Profile : NSObject <NSCoding>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;

- (id)initWithDictionary:(NSDictionary *)values;

- (void)save;

+ (Profile *)loadProfile;
@end