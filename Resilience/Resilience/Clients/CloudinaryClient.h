
#import <Foundation/Foundation.h>
#import "CLUploader.h"
#import "Client.h"

typedef void (^UploadSuccessBlock)(NSString *uploadUrl);

@interface CloudinaryClient : NSObject<CLUploaderDelegate>

- (void)updloadImage:(UIImage *)image success:(UploadSuccessBlock)success failure:(FailureBlock)failure;

+ (NSURL *)imageURLForResource:(NSString *)resource size:(CGSize)size;

@end