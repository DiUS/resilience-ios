#import "IncidentCategory+Image.h"


@implementation IncidentCategory (Image)

- (UIImage *)imageForCategory {
  NSString *name = [[self categoryName] lowercaseString];
  return [UIImage imageNamed:name];
}

@end