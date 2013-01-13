#import "IssueViewController.h"
#import "UIColor+Resilience.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface IssueViewController ()
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *imageLabel;
@end

@implementation IssueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self components];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self style];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self data];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)style {
  self.view.backgroundColor = [UIColor defaultBackgroundColor];
}

- (void)data {
  self.navigationItem.title = self.incident.name;
  NSLog(@"%@", self.incident.imageUrl);
  if (self.incident.imageUrl) {
    [self.imageView setImageWithURL:[NSURL URLWithString:self.incident.imageUrl]];
  }

  self.imageLabel.text = [NSString stringWithFormat:@"%f, %f", self.incident.location.coordinate.longitude, self.incident.location.coordinate.latitude];
}

- (void)components {
  self.imageView = [[UIImageView alloc] initWithImage:nil];
  [self.view addSubview:self.imageView];

  self.imageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.imageLabel.textAlignment = NSTextAlignmentCenter;
  self.imageLabel.backgroundColor = [UIColor clearColor];
  [self.view addSubview:self.imageLabel];
  self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
  self.imageLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.view.translatesAutoresizingMaskIntoConstraints = NO;

  NSDictionary *views = NSDictionaryOfVariableBindings(_imageView, _imageLabel);
  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"|-[_imageLabel]-|"
                              options:0
                              metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[_imageView]-[_imageLabel]-|"
                              options:0
                              metrics:nil views:views]];

  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"|[_imageView]|"
                              options:0
                              metrics:nil views:views]];
}
@end
