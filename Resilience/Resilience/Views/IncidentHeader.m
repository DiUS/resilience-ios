#import "IncidentHeader.h"
#import "Incident.h"

@interface IncidentHeader()
@property (nonatomic, strong) UILabel *issueHeading;
@property (nonatomic, strong) UILabel *reportedTime;
@property (nonatomic, strong) UILabel *issueLocation;
@end

@implementation IncidentHeader

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.issueHeading = [[UILabel alloc] initWithFrame:CGRectZero];
    self.issueHeading.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.issueHeading];

    self.reportedTime = [[UILabel alloc] initWithFrame:CGRectZero];
    self.reportedTime.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.reportedTime];

    self.issueLocation = [[UILabel alloc] initWithFrame:CGRectZero];
    self.issueLocation.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.issueLocation];
  }
  return self;
}

- (void)populateWithIncident:(Incident *)incident {
  self.issueHeading.text = incident.name;
  self.reportedTime.text = [incident createdDateAsString];
  self.issueLocation.text = incident.address;
}

- (CGSize)intrinsicContentSize {

  CGSize issueHeadingSize = [self.issueHeading intrinsicContentSize];
  CGSize issueLocationSize = [self.issueLocation intrinsicContentSize];
  CGSize reportedTimeSize = [self.reportedTime intrinsicContentSize];
  return CGSizeMake(issueHeadingSize.width + issueLocationSize.width + reportedTimeSize.width,
          issueHeadingSize.height + issueLocationSize.height + reportedTimeSize.height + 40);

}


- (void)updateConstraints {
  [super updateConstraints];
  NSDictionary *views = NSDictionaryOfVariableBindings(_issueHeading, _reportedTime, _issueLocation);
  [self addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|-20-[_issueHeading]-10-[_reportedTime]-10-[_issueLocation]-10-|"
                              options:0
                              metrics:nil views:views]];

  [self addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-100-[_issueHeading]"
                              options:0
                              metrics:nil views:views]];

  [self addConstraints:@[
          [NSLayoutConstraint constraintWithItem:self.reportedTime attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.issueHeading
                                       attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
          [NSLayoutConstraint constraintWithItem:self.issueLocation attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.issueHeading
                                       attribute:NSLayoutAttributeLeft multiplier:1 constant:0]
  ]];
}


@end