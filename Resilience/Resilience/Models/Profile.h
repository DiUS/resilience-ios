
#import "MTLModel+NSCoding.h"
#import "MTLJSONAdapter.h"

#define kProfileFirstNameKey       @"firstName"
#define kProfileLastNameKey        @"lastName"
#define kProfileEmailKey           @"email"
#define kProfilePhoneNameKey      @"mobile"

@interface Profile : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;

- (void)save;

+ (Profile *)loadProfile;
@end