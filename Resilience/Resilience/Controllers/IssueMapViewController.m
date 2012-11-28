#import "IssueMapViewController.h"

@interface IssueMapViewController ()

@end

@implementation IssueMapViewController

- (void)viewDidLoad {
  [super viewDidLoad];
//  self.title = @"Issue Maps";
//  UIImage *selectedImage = [UIImage imageNamed:@"TabBar-IssueMapSelected"];
//  UIImage *unselectedImage = [UIImage imageNamed:@"TabBarSelection"];

  self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Issue Maps" image:[UIImage imageNamed:@"TabBar-IssueMap"] tag:0];
//  [self.tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];

  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
