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
@property (nonatomic, strong) UIView *tabBar;
@property (nonatomic, strong) IssueListViewController *issueListViewController;
@property (nonatomic, strong) IssueMapViewController *issueMapViewController;
@property (nonatomic, strong) NSArray *containerConstraints;

@end


@implementation RootViewController

- (void)viewDidLoad {
  UIButton *addIssueButton = [UIButton buttonWithType:UIButtonTypeCustom];
  addIssueButton.frame = CGRectMake(0, 0, 55, 51);
  UIImage *buttonImage = [UIImage imageNamed:@"AddButton"];
  [addIssueButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
  UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:addIssueButton];
  self.navigationItem.rightBarButtonItem = item;
  [addIssueButton addTarget:self action:@selector(addIssue) forControlEvents:UIControlEventTouchUpInside];

  self.tabBar = [[UIView alloc] initWithFrame:CGRectZero];
  self.tabBar.translatesAutoresizingMaskIntoConstraints = NO;

  self.listButton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.listButton.accessibilityIdentifier = @"listButton";
  self.listButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self.listButton setTitle:@" List" forState:UIControlStateNormal];
  [self.listButton setTitleColor:[UIColor colorWithRed:(89.f/255.f) green:(89.f/255.f) blue:(89.f/255.f) alpha:1] forState:UIControlStateNormal];
  [self.listButton addTarget:self action:@selector(showListView) forControlEvents:UIControlEventTouchUpInside];
  [self.listButton setImage:[UIImage imageNamed:@"TabBar-IssueList"] forState:UIControlStateNormal];
  self.listButton.backgroundColor = [UIColor clearColor];
//  [self.listButton setImage:[UIImage imageNamed:@"TabBar-IssueListSelected"] forState:UIControlStateSelected];

  self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.mapButton.accessibilityIdentifier = @"mapButton";
  self.mapButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self.mapButton setTitle:@" Map" forState:UIControlStateNormal];
  [self.mapButton setTitleColor:[UIColor defaultTextColor] forState:UIControlStateNormal];
  [self.mapButton addTarget:self action:@selector(showMapView) forControlEvents:UIControlEventTouchUpInside];
  [self.mapButton setImage:[UIImage imageNamed:@"TabBar-IssueMap"] forState:UIControlStateNormal];
  self.mapButton.backgroundColor = [UIColor clearColor];
//  [self.mapButton setImage:[UIImage imageNamed:@"TabBar-IssueMapSelected"] forState:UIControlStateSelected];

  self.issueListViewController = [[IssueListViewController alloc] init];
  self.issueListViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
  self.issueMapViewController = [[IssueMapViewController alloc] init];
  self.issueMapViewController.view.translatesAutoresizingMaskIntoConstraints = NO;

  [self.tabBar addSubview:self.mapButton];
  [self.tabBar addSubview:self.listButton];
  [self.view addSubview:self.tabBar];

  [self showListView];
  self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews {
  CAGradientLayer *gradient = [CAGradientLayer layer];
  gradient.frame = self.tabBar.bounds;
  UIColor *colorTop = [UIColor colorWithRed:(239.f/255.f) green:(239.f/255.f) blue:(239.f/255.f) alpha:1];
  UIColor *colorBot = [UIColor colorWithRed:(162.f/255.f) green:(162.f/255.f) blue:(162.f/255.f) alpha:1];
  gradient.colors = [NSArray arrayWithObjects:(id)[colorTop CGColor], (id)[colorBot CGColor], nil];
  gradient.masksToBounds = YES;
  [[self.tabBar layer] insertSublayer:gradient atIndex:0];
}

- (void)updateViewConstraints {
  [super updateViewConstraints];

  NSDictionary *views = NSDictionaryOfVariableBindings(_tabBar, _mapButton, _listButton);
  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"|[_tabBar]|"
                              options:NSLayoutFormatAlignAllLeft
                              metrics:nil
                                views:views]];
  [self.tabBar addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"|[_listButton(==_mapButton)]-[_mapButton]|"
                              options:NSLayoutFormatAlignAllBottom
                              metrics:nil
                                views:views]];
  [self.tabBar addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[_listButton(==_mapButton)]|"
                              options:NSLayoutFormatAlignAllBottom
                              metrics:nil
                                views:views]];
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
  UIView *viewToAdd = secondController.view;
  viewToAdd.alpha = 0.;
  [self addChildViewController:secondController];
  [self.view addSubview:viewToAdd];

  NSDictionary *views = NSDictionaryOfVariableBindings(viewToAdd, _tabBar);
  if(self.containerConstraints)
    [self.view removeConstraints:self.containerConstraints];

  self.containerConstraints = [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[viewToAdd][_tabBar(==60)]|"
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