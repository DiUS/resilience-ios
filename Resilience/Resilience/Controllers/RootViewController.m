#import "RootViewController.h"
#import "IssueListViewController.h"
#import "IssueMapViewController.h"
#import "AddIncidentViewController.h"
#import "UIColor+Resilience.h"
#import "ProfileViewController.h"
#import "RSLHeader.h"

@interface RootViewController()

@property (nonatomic, strong) IssueListViewController *issueListViewController;
@property (nonatomic, strong) IssueMapViewController *issueMapViewController;

@property (nonatomic, strong) RSLHeader *header;
@property (nonatomic, strong) UIView *contentView; 

@property (nonatomic, strong) NSArray *containerConstraints;

@end


@implementation RootViewController

- (void)loadView {
  [super loadView];

  self.contentView = [[UIView alloc] init];

  self.header = [[RSLHeader alloc] initWithFrame:CGRectZero];
  [self.header.addIssueButton addTarget:self action:@selector(addIssue) forControlEvents:UIControlEventTouchUpInside];
  [self.header.issueListButton addTarget:self action:@selector(showListView) forControlEvents:UIControlEventTouchUpInside];
  [self.header.issueMapButton addTarget:self action:@selector(showMapView) forControlEvents:UIControlEventTouchUpInside];

  self.issueListViewController = [[IssueListViewController alloc] init];
  self.issueListViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
  
  self.issueMapViewController = [[IssueMapViewController alloc] init];
  self.issueMapViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)viewDidLoad {
  self.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.contentView];
  [self.view addSubview:self.header];
  [self showMapView];
}

- (void)viewDidLayoutSubviews {
  self.header.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), 64.0);
}

- (void)updateViewConstraints {
  [super updateViewConstraints];
}

- (void)showProfile {
  ProfileViewController *profileViewController = [[ProfileViewController alloc] init];

  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
  navController.modalTransitionStyle = profileViewController.modalTransitionStyle;

  [self presentViewController:navController animated:YES completion:nil];
}

- (void) addIssue {
  AddIncidentViewController *incidentViewController = [[AddIncidentViewController alloc] init];

  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:incidentViewController];
  navController.modalTransitionStyle = incidentViewController.modalTransitionStyle;

  [self presentViewController:navController animated:YES completion:nil];
}

- (void) showListView {
  [self swapView:self.issueMapViewController with:self.issueListViewController];
}

- (void) showMapView {
  [self swapView:self.issueListViewController with:self.issueMapViewController];
}

- (void)swapView:(UIViewController *)firstController with:(UIViewController *)secondController {
  if (secondController.view == self.contentView)
    return;

  UIView *viewToAdd = secondController.view;
  viewToAdd.alpha = 0.;
  [self addChildViewController:secondController];
  [self.view insertSubview:viewToAdd belowSubview:self.contentView];
  self.contentView = viewToAdd; 

  [firstController willMoveToParentViewController:nil];
  [firstController removeFromParentViewController];
  [firstController.view removeFromSuperview];
  
  NSDictionary *views = NSDictionaryOfVariableBindings(viewToAdd);
  if(self.containerConstraints)
    [self.view removeConstraints:self.containerConstraints];

  self.containerConstraints = [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|-44-[viewToAdd]|"
                              options:0
                              metrics:nil
                                views:views];
  self.containerConstraints = [self.containerConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|[viewToAdd]|"
                              options:NSLayoutFormatAlignAllLeft
                              metrics:nil
                                views:views]];
  [self.view addConstraints:self.containerConstraints];
  [self.view setNeedsUpdateConstraints];

  [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
    viewToAdd.alpha = 1.0;
  } completion:^(BOOL finished) {
    [secondController didMoveToParentViewController:self];
  }];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {

  if ([viewController isKindOfClass:[RootViewController class]]) {
    [viewController.navigationController setNavigationBarHidden:YES animated:NO];
  } else {
    [viewController.navigationController setNavigationBarHidden:NO animated:NO];
  }
  
}

@end