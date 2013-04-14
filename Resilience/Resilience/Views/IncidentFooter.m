#import <CoreGraphics/CoreGraphics.h>
#import "IncidentFooter.h"
#import "Incident.h"

@interface IncidentFooter()
@property (nonatomic, strong) UILabel *issueDescription;
@end

@implementation IncidentFooter

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.issueDescription = [self labelWithDefaultAttributes];
    [self addSubview:self.issueDescription];

  }
  return self;
}

- (UILabel *)labelWithDefaultAttributes {
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.translatesAutoresizingMaskIntoConstraints = NO;
  label.backgroundColor = [UIColor clearColor];
  return label;
}

- (void)populateWithIncident:(Incident *)incident {
  self.issueDescription.text = incident.description;
}

- (CGSize)intrinsicContentSize {
  return CGSizeMake([self.issueDescription intrinsicContentSize].width, [self.issueDescription intrinsicContentSize].height + 20);
}


- (void)updateConstraints {
  [super updateConstraints];
  NSDictionary *views = NSDictionaryOfVariableBindings(_issueDescription);
  [self addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|-[_issueDescription]-|"
                              options:0
                              metrics:nil views:views]];

  [self addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-[_issueDescription]-|"
                              options:0
                              metrics:nil views:views]];
}


@end