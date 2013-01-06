#import <Foundation/Foundation.h>


@interface Service : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *serviceDescription;
@property (nonatomic, assign) BOOL *metadata;
@property (nonatomic, strong) NSString *type; // TODO: enum
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSString *group;

@end