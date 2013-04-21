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
  //TODO: hookup add button
  //[addIssueButton addTarget:self action:@selector(addIssue) forControlEvents:UIControlEventTouchUpInside];
  
  //TODO: hookup other buttons
  //  UIBarButtonItem *profileItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Assets/SettingsIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(showProfile)];
  //  profileItem.tintColor = [UIColor orangeColor];
  //  UIBarButtonItem *feedbackbuttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Assets/FeedbackIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(showProfile)];
  //  feedbackbuttonItem.tintColor = [UIColor orangeColor];


  self.issueListViewController = [[IssueListViewController alloc] init];
  self.issueListViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
  
  self.issueMapViewController = [[IssueMapViewController alloc] init];
  self.issueMapViewController.view.translatesAutoresizingMaskIntoConstraints = NO;

  //UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  //[self setToolbarItems:@[feedbackbuttonItem, flexibleSpace, profileItem]];
}

- (void)viewDidLoad {
  self.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.contentView];
  [self.view addSubview:self.header];
  [self showMapView];
}

- (void)viewWillAppear:(BOOL)animated {
  self.navigationController.toolbarHidden = YES;
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
  [firstController willMoveToParentViewController:nil];
  [firstController removeFromParentViewController];
  [firstController.view removeFromSuperview];
  UIView *viewToAdd = secondController.view;
  viewToAdd.alpha = 0.;
  [self addChildViewController:secondController];
  [self.view insertSubview:viewToAdd aboveSubview:self.contentView];
  self.contentView = viewToAdd; 

  NSDictionary *views = NSDictionaryOfVariableBindings(viewToAdd);
  if(self.containerConstraints)
    [self.view removeConstraints:self.containerConstraints];

  self.containerConstraints = [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[viewToAdd]|"
                              options:0
                              metrics:nil
                                views:views];
  self.containerConstraints = [self.containerConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|[viewToAdd]|" //Add gap to let avoid disappering behind 
                              options:NSLayoutFormatAlignAllLeft
                              metrics:nil
                                views:views]];
  [self.view addConstraints:self.containerConstraints];
  [self.view setNeedsUpdateConstraints];

  [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
    viewToAdd.alpha = 0.5;
  } completion:^(BOOL finished) {
    [secondController didMoveToParentViewController:self];
  }];
}

@end