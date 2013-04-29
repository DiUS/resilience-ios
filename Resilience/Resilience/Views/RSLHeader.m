#import "RSLHeader.h"

@interface RSLHeader()

@property (nonatomic, strong) UIImageView *headerBackground;

@end

@implementation RSLHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      UIImage *resizableBackground = [[UIImage imageNamed:@"Assets/TitleBarWithBump"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 65.0, 64.0)];
      self.headerBackground = [[UIImageView alloc] initWithImage:resizableBackground];
      [self addSubview:self.headerBackground];

      self.addIssueButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [self.addIssueButton setImage:[UIImage imageNamed:@"Assets/AddIssueButton"] forState:UIControlStateNormal];
      [self.addIssueButton setImage:[UIImage imageNamed:@"Assets/AddIssueButtonHighlighted"] forState:UIControlStateHighlighted];
      [self addSubview:self.addIssueButton];

      self.issueMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [self.issueMapButton setImage:[UIImage imageNamed:@"Assets/issueMapOff"] forState:UIControlStateNormal];
      [self.issueMapButton setImage:[UIImage imageNamed:@"Assets/issueMapOn"] forState:UIControlStateSelected];
      [self.issueMapButton addTarget:self action:@selector(selectMapViewButton) forControlEvents:UIControlEventTouchUpInside];
      self.issueMapButton.selected = YES;
      [self addSubview:self.issueMapButton];

      self.issueListButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [self.issueListButton setImage:[UIImage imageNamed:@"Assets/issueListOff"] forState:UIControlStateNormal];
      [self.issueListButton setImage:[UIImage imageNamed:@"Assets/issueListOn"] forState:UIControlStateSelected];
      [self.issueListButton addTarget:self action:@selector(selectListViewButton) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:self.issueListButton];
    }
    return self;
}

- (void) selectMapViewButton {
  self.issueMapButton.selected = YES;
  self.issueListButton.selected = NO;
}

- (void) selectListViewButton {
  self.issueMapButton.selected = NO;
  self.issueListButton.selected = YES;
}

- (void)layoutSubviews {
  self.headerBackground.frame = self.bounds;

  //Layout buttons
  self.addIssueButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - (self.addIssueButton.imageView.image.size.width + 9),
                                         4.0,
                                         self.addIssueButton.imageView.image.size.width,
                                         self.addIssueButton.imageView.image.size.height);

  self.issueMapButton.frame = CGRectMake((CGRectGetWidth(self.bounds) / 2) - self.issueMapButton.imageView.image.size.width,
                                         10.0,
                                         self.issueMapButton.imageView.image.size.width,
                                         self.issueMapButton.imageView.image.size.height);

  self.issueListButton.frame = CGRectMake((CGRectGetWidth(self.bounds) / 2),
                                          10.0,
                                          self.issueMapButton.imageView.image.size.width,
                                          self.issueMapButton.imageView.image.size.height);
}

@end
