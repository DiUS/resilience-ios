#import "RSLHeader.h"

@interface RSLHeader()

@property (nonatomic, strong) UIImageView *headerBackground;

@end

@implementation RSLHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      UIImage *resizableBackground = [[UIImage imageNamed:@"Assets/TitleBarWithBump"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 1.0, 2.0, 2.0) resizingMode:UIImageResizingModeStretch];
      self.headerBackground = [[UIImageView alloc] initWithImage:resizableBackground];
      [self addSubview:self.headerBackground];

      self.addIssueButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [self.addIssueButton setImage:[UIImage imageNamed:@"Assets/AddIssueButton"] forState:UIControlStateNormal];
      [self.addIssueButton setImage:[UIImage imageNamed:@"Assets/AddIssueButtonHighlighted"] forState:UIControlStateHighlighted];
      [self addSubview:self.addIssueButton];

      self.issueMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [self.issueMapButton setImage:[UIImage imageNamed:@"Assets/issueMapOff"] forState:UIControlStateNormal];
      [self.issueMapButton setImage:[UIImage imageNamed:@"Assets/issueMapOn"] forState:UIControlStateSelected];
      [self addSubview:self.issueMapButton];

      self.issueListButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [self.issueListButton setImage:[UIImage imageNamed:@"Assets/issueListOff"] forState:UIControlStateNormal];
      [self.issueListButton setImage:[UIImage imageNamed:@"Assets/issueListOn"] forState:UIControlStateSelected];
      [self addSubview:self.issueListButton];
    }
    return self;
}

- (void)layoutSubviews {
  self.headerBackground.frame = self.bounds;

  //Layout buttons
  self.addIssueButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(self.addIssueButton.bounds),
                                         0.0,
                                         CGRectGetWidth(self.addIssueButton.bounds),
                                         CGRectGetHeight(self.addIssueButton.bounds));

  self.issueMapButton.frame = CGRectMake((CGRectGetWidth(self.bounds) / 2) - CGRectGetWidth(self.addIssueButton.bounds),
                                         0.0,
                                         CGRectGetWidth(self.issueMapButton.bounds),
                                         CGRectGetHeight(self.issueMapButton.bounds));

  self.issueListButton.frame = CGRectMake((CGRectGetWidth(self.bounds) / 2),
                                          0.0,
                                          CGRectGetWidth(self.issueMapButton.bounds),
                                          CGRectGetHeight(self.issueMapButton.bounds));
}

@end
