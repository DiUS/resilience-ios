#import <CoreGraphics/CoreGraphics.h>
#import "IncidentDetails.h"
#import "Incident.h"
#import "UIColor+Resilience.h"

@interface IncidentDetails ()
@property (nonatomic, strong) UILabel *incidentDescription;
@property (nonatomic, strong) UILabel *incidentHeading;
@property (nonatomic, strong) UILabel *reportedTime;
@property (nonatomic, strong) UILabel *incidentLocation;
@end

@implementation IncidentDetails

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {

    self.reportedTime = [self labelWithDefaultAttributes];
    self.reportedTime.font = [UIFont boldSystemFontOfSize:12];
    self.reportedTime.textColor = [UIColor lightGreyTextColor];
    [self addSubview:self.reportedTime];

    self.incidentHeading = [self labelWithDefaultAttributes];
    self.incidentHeading.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:self.incidentHeading];

    self.incidentLocation = [self labelWithDefaultAttributes];;
    self.incidentLocation.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.incidentLocation];

    self.incidentDescription = [self labelWithDefaultAttributes];

    [self addSubview:self.incidentDescription];

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
  self.incidentDescription.text = incident.description;
  self.incidentHeading.text = incident.name;
  self.incidentLocation.text = incident.address;
  self.incidentDescription.textAlignment = NSTextAlignmentLeft;
  [self.incidentLocation sizeToFit];
  [self.incidentHeading sizeToFit];
}


- (void)updateConstraints {
  [super updateConstraints];
  NSDictionary *views = NSDictionaryOfVariableBindings(_incidentDescription, _incidentHeading, _reportedTime, _incidentLocation);
  [self addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[_reportedTime(15)]-[_incidentHeading(30)]-[_incidentLocation(10)]-[_incidentDescription]-(>=15)-|"
                              options:0
                              metrics:nil views:views]];

  [self addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-[_incidentLocation]-|"
                              options:0
                              metrics:nil views:views]];


  [self addConstraints:@[
          [NSLayoutConstraint constraintWithItem:self.incidentHeading attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.incidentLocation
                                       attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
          [NSLayoutConstraint constraintWithItem:self.reportedTime attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.incidentLocation
                                       attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
          [NSLayoutConstraint constraintWithItem:self.incidentDescription attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.incidentLocation
                                       attribute:NSLayoutAttributeLeft multiplier:1 constant:0]
  ]];
}


@end