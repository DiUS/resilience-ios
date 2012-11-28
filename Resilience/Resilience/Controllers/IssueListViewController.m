
#import "IssueListViewController.h"

@interface IssueListViewController ()

@end

@implementation IssueListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Issue List" image:[UIImage imageNamed:@"TabBar-IssueList"] tag:0];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
