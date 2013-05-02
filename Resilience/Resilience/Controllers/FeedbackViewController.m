#import <NoticeView/WBErrorNoticeView.h>
#import "FeedbackViewController.h"
#import "UITextField+Form.h"
#import "UIColor+Resilience.h"
#import "UIView+WSLoading.h"
#import "Open311Client.h"

@interface FeedbackViewController ()

@property (nonatomic, strong) UITextField *contentTextField;
@property (nonatomic, strong) UILabel *headingLabel;

@end

@implementation FeedbackViewController

- (void)loadView {
  [super loadView];
  self.title = @"Feedback";
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(send:)];
  self.navigationItem.rightBarButtonItem.title = @"Send feedback";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
  self.navigationItem.leftBarButtonItem.title = @"Send feedback";
  self.contentTextField = [UITextField multilineTextField:@"Comments..."];
  self.contentTextField.translatesAutoresizingMaskIntoConstraints = NO;
  self.headingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.headingLabel.text = @"Message:";
  self.headingLabel.backgroundColor = [UIColor clearColor];
  self.headingLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.view.backgroundColor = [UIColor defaultBackgroundColor];
  [self.view addSubview:self.headingLabel];
  [self.view addSubview:self.contentTextField];
}

- (void)viewWillAppear:(BOOL)animated {

}

- (void)updateViewConstraints {
  [super updateViewConstraints];

  NSDictionary *views = NSDictionaryOfVariableBindings(_headingLabel, _contentTextField);
  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|-[_headingLabel(==50)]-[_contentTextField]-|"
                              options:0
                              metrics:nil views:views]];

  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-[_headingLabel]-|"
                              options:0
                              metrics:nil views:views]];

  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-[_contentTextField]-|"
                              options:0
                              metrics:nil views:views]];

}

- (void)send:(id)sender {
  [self.view showLoading];
  [[Open311Client sharedClient] sendFeedback:self.contentTextField.text success:^{
    [self.view hideLoading];
    [self dismissViewControllerAnimated:YES completion:nil];
  } failure:^(NSError *error) {
    [self.view hideLoading];
    WBErrorNoticeView *errorView = [[WBErrorNoticeView alloc] initWithView:self.view title:@"Error sending feedback."];
    errorView.message = error.localizedDescription;
    errorView.alpha = 0.9;
    errorView.floating = YES;
    [errorView show];
  }];
}

- (void)cancel:(id)cancel {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end