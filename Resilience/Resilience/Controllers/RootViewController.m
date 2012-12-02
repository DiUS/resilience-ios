#import <QuartzCore/QuartzCore.h>
#import "RootViewController.h"
//#import "UIBarButtonItem+BlocksKit.h"
#import "IssueListViewController.h"
#import "IssueMapViewController.h"
#import "AddIncidentViewController.h"
#import "UIColor+Resilience.h"

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

  UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 356, 320, 60)];
  CAGradientLayer *gradient = [CAGradientLayer layer];
  gradient.frame = tabBar.bounds;
  UIColor *colorTop = [UIColor colorWithRed:(239.f/255.f) green:(239.f/255.f) blue:(239.f/255.f) alpha:1];
  UIColor *colorBot = [UIColor colorWithRed:(162.f/255.f) green:(162.f/255.f) blue:(162.f/255.f) alpha:1];
  gradient.colors = [NSArray arrayWithObjects:(id)[colorTop CGColor], (id)[colorBot CGColor], nil];
  gradient.masksToBounds = YES;
  [[tabBar layer] insertSublayer:gradient atIndex:0];

  self.listButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.listButton setTitle:@" List" forState:UIControlStateNormal];
  [self.listButton setTitleColor:[UIColor colorWithRed:(89.f/255.f) green:(89.f/255.f) blue:(89.f/255.f) alpha:1] forState:UIControlStateNormal];
  [self.listButton addTarget:self action:@selector(showListView) forControlEvents:UIControlEventTouchUpInside];
  [self.listButton setImage:[UIImage imageNamed:@"TabBar-IssueList"] forState:UIControlStateNormal];
  self.listButton.backgroundColor = [UIColor clearColor];
//  [self.listButton setImage:[UIImage imageNamed:@"TabBar-IssueListSelected"] forState:UIControlStateSelected];

  self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.mapButton setTitle:@" Map" forState:UIControlStateNormal];
  [self.mapButton setTitleColor:[UIColor defaultTextColor] forState:UIControlStateNormal];
  [self.mapButton addTarget:self action:@selector(showMapView) forControlEvents:UIControlEventTouchUpInside];
  [self.mapButton setImage:[UIImage imageNamed:@"TabBar-IssueMap"] forState:UIControlStateNormal];
  self.mapButton.backgroundColor = [UIColor clearColor];
//  [self.mapButton setImage:[UIImage imageNamed:@"TabBar-IssueMapSelected"] forState:UIControlStateSelected];

  self.mapButton.frame = CGRectMake(tabBar.frame.size.width / 2, 0, tabBar.frame.size.width / 2, tabBar.frame.size.height);
  self.listButton.frame = CGRectMake(0, 0, tabBar.frame.size.width / 2, tabBar.frame.size.height);

  self.issueListViewController = [[IssueListViewController alloc] init];
  self.issueMapViewController = [[IssueMapViewController alloc] init];

  [tabBar addSubview:self.mapButton];
  [tabBar addSubview:self.listButton];
  [self.view addSubview:tabBar];

  [self showListView];
  self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillLayoutSubviews {
  self.issueListViewController.view.frame = CGRectMake(0, 0, 320, 356);
  self.issueMapViewController.view.frame = CGRectMake(0, 0, 320, 356);
}

- (void) addIssue {
  AddIncidentViewController *incidentViewController = [[AddIncidentViewController alloc] init];

  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:incidentViewController];
  navController.modalTransitionStyle = incidentViewController.modalTransitionStyle;

  [self presentViewController:navController animated:YES completion:nil];
}

- (void) showListView {
  [self swapView:self.issueMapViewController with:self.issueListViewController];
  self.listButton.selected = YES;
  self.mapButton.selected = NO;
}

- (void) showMapView {
  [self swapView:self.issueListViewController with:self.issueMapViewController];
  self.listButton.selected = NO;
  self.mapButton.selected = YES;
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