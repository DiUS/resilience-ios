#import <CoreGraphics/CoreGraphics.h>
#import "IncidentDetails.h"
#import "Incident.h"
#import "UIColor+Resilience.h"

@interface IncidentDetails ()
@property (nonatomic, strong) UILabel *issueDescription;
@property (nonatomic, strong) UILabel *issueHeading;
@property (nonatomic, strong) UILabel *reportedTime;
@property (nonatomic, strong) UILabel *issueLocation;
@end

@implementation IncidentDetails

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {

    self.reportedTime = [self labelWithDefaultAttributes];
    self.reportedTime.font = [UIFont boldSystemFontOfSize:12];
    self.reportedTime.textColor = [UIColor lightGreyTextColor];
    [self addSubview:self.reportedTime];

    self.issueHeading = [self labelWithDefaultAttributes];
    self.issueHeading.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:self.issueHeading];

    self.issueLocation = [self labelWithDefaultAttributes];;
    self.issueLocation.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.issueLocation];

    self.issueDescription = [self labelWithDefaultAttributes];

    [self addSubview:self.issueDescription];

  }
  return self;
}

- (UILabel *)labelWithDefaultAttributes {
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.translatesAutoresizingMaskIntoConstraints = NO;
  label.backgroundColor = [UIColor clearColor];
  label.textColor = [UIColor defaultTextColor];
  label.numberOfLines = 0;
  [label setPreferredMaxLayoutWidth:280.];

  return label;
}

- (void)populateWithIncident:(Incident *)incident {
  self.reportedTime.text = [incident createdDateAsString];
  self.issueDescription.text = incident.description;
  self.issueHeading.text = incident.name;
  self.issueLocation.text = incident.address;
  self.issueDescription.textAlignment = NSTextAlignmentLeft;
  [self.issueLocation sizeToFit];
  [self.issueHeading sizeToFit];
}


- (void)updateConstraints {
  [super updateConstraints];
  NSDictionary *views = NSDictionaryOfVariableBindings(_issueDescription, _issueHeading, _reportedTime, _issueLocation);
  [self addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[_reportedTime(15)]-[_issueHeading(30)]-[_issueLocation(10)]-[_issueDescription]-(>=15)-|"
                              options:0
                              metrics:nil views:views]];

  [self addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-[_issueLocation]-|"
                              options:0
                              metrics:nil views:views]];


  [self addConstraints:@[
          [NSLayoutConstraint constraintWithItem:self.issueHeading attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.issueLocation
                                       attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
          [NSLayoutConstraint constraintWithItem:self.reportedTime attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.issueLocation
                                       attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
          [NSLayoutConstraint constraintWithItem:self.issueDescription attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.issueLocation
                                       attribute:NSLayoutAttributeLeft multiplier:1 constant:0]
  ]];
}


@end