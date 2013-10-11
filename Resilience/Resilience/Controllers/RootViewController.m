#import <NoticeView/WBErrorNoticeView.h>
#import "RootViewController.h"
#import "IncidentListViewController.h"
#import "IncidentMapViewController.h"
#import "AddIncidentViewController.h"
#import "UIColor+Resilience.h"
#import "ProfileViewController.h"
#import "RSLHeader.h"
#import "WBNoticeView.h"
#import "WBSuccessNoticeView.h"
#import "AppNotifications.h"
#import "WBStickyNoticeView.h"
#import "FeedbackViewController.h"
#import "UIDevice+iOS7.h"

@interface RootViewController()

@property (nonatomic, strong) IncidentListViewController *incidentListViewController;
@property (nonatomic, strong) IncidentMapViewController *incidentMapViewController;
@property (nonatomic, strong) RSLHeader *header;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray *containerConstraints;

@end


@implementation RootViewController

- (void)loadView {
  [super loadView];

  self.contentView = [[UIView alloc] init];

  self.header = [[RSLHeader alloc] initWithFrame:CGRectZero];
  [self.header.addIncidentButton addTarget:self action:@selector(addIncident) forControlEvents:UIControlEventTouchUpInside];
  [self.header.incidentListButton addTarget:self action:@selector(showListView) forControlEvents:UIControlEventTouchUpInside];
  [self.header.incidentMapButton addTarget:self action:@selector(showMapView) forControlEvents:UIControlEventTouchUpInside];

  self.incidentListViewController = [[IncidentListViewController alloc] init];
  self.incidentListViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
  
  self.incidentMapViewController = [[IncidentMapViewController alloc] init];
  self.incidentMapViewController.view.translatesAutoresizingMaskIntoConstraints = NO;

  self.toolbar = [[UIToolbar alloc] init];
  UIBarButtonItem *profileItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Assets/SettingsIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(showProfile)];
  profileItem.tintColor = [UIColor orangeColor];
  UIBarButtonItem *feedbackButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Assets/FeedbackIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(showFeedback)];
  feedbackButtonItem.tintColor = [UIColor orangeColor];
  UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  [self.toolbar setItems:@[feedbackButtonItem, flexibleSpace, profileItem]];

  [[NSNotificationCenter defaultCenter] addObserverForName:kIncidentUploadedSuccessfully object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    WBSuccessNoticeView *successNoticeView = [[WBSuccessNoticeView alloc] initWithView:self.view title:NSLocalizedString(@"incidentUpload:Successful:Title", @"Successfully reported incident.")];
    successNoticeView.alpha = 0.9;
    [successNoticeView show];
    [self.incidentListViewController loadIncidents];
  }];
  [[NSNotificationCenter defaultCenter] addObserverForName:kIncidentUploadFailed object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    WBStickyNoticeView *noticeView = [[WBStickyNoticeView alloc] initWithView:self.view title:NSLocalizedString(@"incidentUpload:Failed:Title", @"Could not upload incident at this time.")];
    noticeView.alpha = 0.9;
    noticeView.sticky = NO;
    [noticeView show];
  }];
}

- (void)viewDidLoad {
  self.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.contentView];
  [self.view addSubview:self.header];
  [self.view addSubview:self.toolbar];
  [self showListView];
}

- (void)viewDidLayoutSubviews {
  float vheight = [UIDevice iOS7] ? 84. : 64.;
  self.header.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), vheight);
  self.toolbar.frame = CGRectMake(0.0, CGRectGetHeight(self.view.frame) - 44.0, CGRectGetWidth(self.view.frame), 44.0);
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

- (void)showFeedback {
  FeedbackViewController *feedbackViewController = [[FeedbackViewController alloc] init];

  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
  navController.modalTransitionStyle = feedbackViewController.modalTransitionStyle;

  [self presentViewController:navController animated:YES completion:nil];
}


- (void)addIncident {
  AddIncidentViewController *incidentViewController = [[AddIncidentViewController alloc] init];

  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:incidentViewController];
  navController.modalTransitionStyle = incidentViewController.modalTransitionStyle;

  [self presentViewController:navController animated:YES completion:nil];
}

- (void)showListView {
  [self swapView:self.incidentMapViewController with:self.incidentListViewController];
}

- (void)showMapView {
  [self swapView:self.incidentListViewController with:self.incidentMapViewController];
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

  NSNumber *vpadding = [UIDevice iOS7] ? @64 : @44;
  self.containerConstraints = [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|-vpadding-[viewToAdd]-44-|"
                              options:0
                              metrics:@{ @"vpadding": vpadding }
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


@end