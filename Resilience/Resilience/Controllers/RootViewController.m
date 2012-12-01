#import "RootViewController.h"
#import "UIBarButtonItem+BlocksKit.h"
#import "IssueListViewController.h"
#import "IssueMapViewController.h"
#import "AddIncidentViewController.h"

@interface RootViewController()

@property (nonatomic, strong) UIButton *mapButton;
@property (nonatomic, strong) UIButton *listButton;
@property (nonatomic, strong) IssueListViewController *issueListViewController;
@property (nonatomic, strong) IssueMapViewController *issueMapViewController;

@end


@implementation RootViewController

- (void)viewDidLoad {
  // TODO: Use Autolayout
  UIButton *addIssueButton = [UIButton buttonWithType:UIButtonTypeCustom];
  addIssueButton.frame = CGRectMake(0, 0, 55, 51);
  UIImage *buttonImage = [UIImage imageNamed:@"AddButton"];
  [addIssueButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
  UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:addIssueButton];
  self.navigationItem.rightBarButtonItem = item;
  [addIssueButton addTarget:self action:@selector(addIssue) forControlEvents:UIControlEventTouchUpInside];

  self.listButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.listButton setTitle:@"List" forState:UIControlStateNormal];
  [self.listButton addTarget:self action:@selector(showListView) forControlEvents:UIControlEventTouchUpInside];

  self.mapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.mapButton setTitle:@"Map" forState:UIControlStateNormal];
  [self.mapButton addTarget:self action:@selector(showMapView) forControlEvents:UIControlEventTouchUpInside];

  self.mapButton.frame = CGRectMake(140, 340, 100, 50);
  self.listButton.frame = CGRectMake(20, 340, 100, 50);

  self.issueListViewController = [[IssueListViewController alloc] init];
  self.issueListViewController.view.frame = CGRectMake(0, 0, 320, 310);

  self.issueMapViewController = [[IssueMapViewController alloc] init];
  self.issueMapViewController.view.frame = CGRectMake(0, 0, 320, 310);

  [self.view addSubview:self.mapButton];
  [self.view addSubview:self.listButton];

  [self showListView];
  self.view.backgroundColor = [UIColor whiteColor];
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
  secondController.view.alpha = 0.;

  [self addChildViewController:secondController];
  [[self view] addSubview:secondController.view];

  [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
    secondController.view.alpha = 1.;
  } completion:^(BOOL finished) {
    [secondController didMoveToParentViewController:self];
  }];
}

@end