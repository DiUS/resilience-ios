#import "RSLHeader.h"

@interface RSLHeader()

@property (nonatomic, strong) UIImageView *headerBackground;

@end

@implementation RSLHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      UIImage *resizableBackground = [[UIImage imageNamed:@"Assets/TitleBarWithBump"] resizableImageWithCapInsets:UIEdgeInsetsMake(3.0, 1.0, 65.0, 64.0)];
      self.headerBackground = [[UIImageView alloc] initWithImage:resizableBackground];
      [self addSubview:self.headerBackground];

      self.addIncidentButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [self.addIncidentButton setImage:[UIImage imageNamed:@"Assets/AddIssueButton"] forState:UIControlStateNormal];
      [self.addIncidentButton setImage:[UIImage imageNamed:@"Assets/AddIssueButtonHighlighted"] forState:UIControlStateHighlighted];
      [self addSubview:self.addIncidentButton];

      self.incidentMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [self.incidentMapButton setImage:[UIImage imageNamed:@"Assets/issueMapOff"] forState:UIControlStateNormal];
      [self.incidentMapButton setImage:[UIImage imageNamed:@"Assets/issueMapOn"] forState:UIControlStateSelected];
      [self.incidentMapButton addTarget:self action:@selector(selectMapViewButton) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:self.incidentMapButton];

      self.incidentListButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [self.incidentListButton setImage:[UIImage imageNamed:@"Assets/issueListOff"] forState:UIControlStateNormal];
      [self.incidentListButton setImage:[UIImage imageNamed:@"Assets/issueListOn"] forState:UIControlStateSelected];
      [self.incidentListButton addTarget:self action:@selector(selectListViewButton) forControlEvents:UIControlEventTouchUpInside];
      self.incidentListButton.selected = YES;
      [self addSubview:self.incidentListButton];
    }
    return self;
}

- (void) selectMapViewButton {
  self.incidentMapButton.selected = YES;
  self.incidentListButton.selected = NO;
}

- (void) selectListViewButton {
  self.incidentMapButton.selected = NO;
  self.incidentListButton.selected = YES;
}

- (void)layoutSubviews {
  self.headerBackground.frame = self.bounds;

  //Layout buttons
  self.addIncidentButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - (self.addIncidentButton.imageView.image.size.width + 9),
                                         24.0,
                                         self.addIncidentButton.imageView.image.size.width,
                                         self.addIncidentButton.imageView.image.size.height);

  self.incidentMapButton.frame = CGRectMake((CGRectGetWidth(self.bounds) / 2) - self.incidentMapButton.imageView.image.size.width,
                                         30.0,
                                         self.incidentMapButton.imageView.image.size.width,
                                         self.incidentMapButton.imageView.image.size.height);

  self.incidentListButton.frame = CGRectMake((CGRectGetWidth(self.bounds) / 2),
                                          30.0,
                                          self.incidentMapButton.imageView.image.size.width,
                                          self.incidentMapButton.imageView.image.size.height);
}

@end
