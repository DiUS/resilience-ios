#import <CoreGraphics/CoreGraphics.h>
#import "CloudinaryClient.h"
#import "CLTransformation.h"

@interface CloudinaryClient()

@property (nonatomic, strong) CLUploader *uploader;
@property (nonatomic, copy) UploadSuccessBlock uploadSuccessBlock;
@property (nonatomic, copy) FailureBlock uploadFailureBlock;

@end

@implementation CloudinaryClient

+ (CLCloudinary *)sharedCloudinary {
  static CLCloudinary *_sharedCloudinary = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedCloudinary = [[CLCloudinary alloc] init];
    [_sharedCloudinary.config setValue:@"resilience" forKey:@"cloud_name"];
    [_sharedCloudinary.config setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CloudinaryApiKey"] forKey:@"api_key"];
    [_sharedCloudinary.config setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CloudinaryApiSecret"] forKey:@"api_secret"];
  });

  return _sharedCloudinary;
}

- (id)init {
  if (self = [super init]) {
    self.uploader = [[CLUploader alloc] init:[CloudinaryClient sharedCloudinary] delegate:self];
  }
  return self;
}

- (void)updloadImage:(UIImage *)image success:(UploadSuccessBlock)success failure:(FailureBlock)failure {
  self.uploadSuccessBlock = success;
  self.uploadFailureBlock = failure;
  [self.uploader upload:UIImageJPEGRepresentation(image, 0.50f) options:@{}];
}

#pragma mark - CLUploaderDelegate
- (void) uploaderSuccess:(NSDictionary*)result context:(id)context {
  NSString* publicId = [result valueForKey:@"public_id"];
  NSLog(@"Upload success. Public ID=%@, Full result=%@", publicId, result);
  self.uploadSuccessBlock([NSString stringWithFormat:@"%@.%@", [result valueForKey:@"public_id"], [result valueForKey:@"format"]]);
}

- (void) uploaderError:(NSString*)result code:(int) code context:(id)context {
  NSLog(@"Upload error: %@, %d", result, code);
  self.uploadFailureBlock([NSError errorWithDomain:@"upload" code:code userInfo:@{ @"result": result }]);
}

- (void) uploaderProgress:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite context:(id)context {
  NSLog(@"Upload progress: %d/%d (+%d)", totalBytesWritten, totalBytesExpectedToWrite, bytesWritten);
}

+ (NSURL *)imageURLForResource:(NSString *)resource size:(CGSize)size {
  CLTransformation *transformation = [CLTransformation transformation];
  [transformation setWidthWithInt: (int)size.width];
  [transformation setHeightWithInt: (int)size.height];
  [transformation setCrop: @"fill"];

  return [NSURL URLWithString:[[CloudinaryClient sharedCloudinary] url:resource options:[NSDictionary dictionaryWithObjectsAndKeys:transformation, @"transformation", nil]]];
}

@end