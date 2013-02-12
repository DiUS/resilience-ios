#import "IncidentHeader.h"
#import "IssueViewController.h"
#import "UIColor+Resilience.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <MapKit/MapKit.h>

@interface IssueViewController ()
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) MKMapView *issueMap;
@property(nonatomic, strong) IncidentHeader *headerView;
@end

@implementation IssueViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self data];
}

- (void)viewDidLoad {
  [self style];
}

- (void)loadView {
  [self components];
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

  if (self.incident.imageUrl) {
    [self.imageView setImageWithURL:[NSURL URLWithString:self.incident.imageUrl]];
  }

  [self.headerView populateWithIncident:self.incident];

//  self.imageLabel.text = [NSString stringWithFormat:@"%f, %f", self.incident.location.coordinate.longitude, self.incident.location.coordinate.latitude];
}

- (void)components {
  self.view = [[UIView alloc] initWithFrame:CGRectZero];

  self.imageView = [[UIImageView alloc] initWithImage:nil];
  self.imageView.contentMode = UIViewContentModeScaleToFill;
  [self.view addSubview:self.imageView];

  self.headerView = [[IncidentHeader alloc] initWithFrame:CGRectZero];
  [self.view addSubview:self.headerView];

  self.navigationItem.title = @"Issue Details";

  self.issueMap = [[MKMapView alloc] initWithFrame:CGRectZero];
  [self.view addSubview:self.issueMap];

  self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
  self.issueMap.translatesAutoresizingMaskIntoConstraints = NO;
  self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
  self.view.translatesAutoresizingMaskIntoConstraints = NO;

}


- (void)updateViewConstraints {
  [super updateViewConstraints];
  NSDictionary *views = NSDictionaryOfVariableBindings(_imageView, _issueMap, _headerView);
  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[_headerView]-[_imageView(185)]|"
                              options:0
                              metrics:nil views:views]];

  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[_headerView]-[_issueMap(185)]"
                              options:0
                              metrics:nil views:views]];

  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|[_headerView]|"
                              options:0
                              metrics:nil views:views]];

  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-32-[_imageView(120)]-32-[_issueMap(120)]-32-|"
                              options:0
                              metrics:nil views:views]];
}

@end
