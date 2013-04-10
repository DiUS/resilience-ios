#import "RootViewController.h"
#import "IssueListViewController.h"
#import "IssueMapViewController.h"
#import "AddIncidentViewController.h"
#import "UIColor+Resilience.h"
#import "ProfileViewController.h"

@interface RootViewController()

@property (nonatomic, strong) IssueListViewController *issueListViewController;
@property (nonatomic, strong) IssueMapViewController *issueMapViewController;
@property (nonatomic, strong) UISegmentedControl *toggleSegmentedControl;
@property (nonatomic, strong) NSArray *containerConstraints;

@end


@implementation RootViewController

- (void)loadView {
  [super loadView];
  UIButton *addIssueButton = [UIButton buttonWithType:UIButtonTypeCustom];
  addIssueButton.frame = CGRectMake(0, 0, 55, 51);
  UIImage *buttonImage = [UIImage imageNamed:@"Assets/AddButton"];
  [addIssueButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
  [addIssueButton addTarget:self action:@selector(addIssue) forControlEvents:UIControlEventTouchUpInside];

  UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:addIssueButton];
  self.navigationItem.rightBarButtonItem = item;
  self.toggleSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[ [UIImage imageNamed:@"Assets/TabBar-IssueList"],  [UIImage imageNamed:@"Assets/TabBar-IssueMap"] ]];
  self.toggleSegmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
  self.toggleSegmentedControl.selectedSegmentIndex = 0;
  [self.toggleSegmentedControl addTarget:self action:@selector(toggleView) forControlEvents:UIControlEventValueChanged];
  [self.navigationController.navigationBar addSubview:self.toggleSegmentedControl];

  self.issueListViewController = [[IssueListViewController alloc] init];
  self.issueListViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
  self.issueMapViewController = [[IssueMapViewController alloc] init];
  self.issueMapViewController.view.translatesAutoresizingMaskIntoConstraints = NO;

  UIBarButtonItem *profileItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Assets/SettingsIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(showProfile)];
//  UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"SettingsIcon" style:UIBarButtonItemStyleBordered target:self action:@selector(showProfile)];
  UIBarButtonItem *feedbackbuttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Assets/FeedbackIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(showProfile)];
  UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  [self setToolbarItems:@[feedbackbuttonItem, flexibleSpace, profileItem]];
}

- (void)viewDidLoad {
  [self showListView];
  self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
  self.navigationController.toolbarHidden = NO;
  self.toggleSegmentedControl.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
//  self.navigationController.toolbarHidden = YES;
  self.toggleSegmentedControl.hidden = YES;
}

- (void)viewDidLayoutSubviews {

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

- (void)toggleView {
  if(self.toggleSegmentedControl.selectedSegmentIndex == 0) {
    [self showListView];
  } else {
    [self showMapView];
  }
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
  [self.view addSubview:viewToAdd];

  NSDictionary *views = NSDictionaryOfVariableBindings(viewToAdd);
  if(self.containerConstraints)
    [self.view removeConstraints:self.containerConstraints];

  self.containerConstraints = [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[viewToAdd]|"
                              options:0
                              metrics:nil
                                views:views];
  self.containerConstraints = [self.containerConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint
          constraintsWithVisualFormat:@"|[viewToAdd]|"
                              options:NSLayoutFormatAlignAllLeft
                              metrics:nil
                                views:views]];
  [self.view addConstraints:self.containerConstraints];
  [self.view setNeedsUpdateConstraints];

  [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
    viewToAdd.alpha = 1.;
  } completion:^(BOOL finished) {
    [secondController didMoveToParentViewController:self];
  }];
}

@end