//
//  IssueViewController.m
//  Resilience
//
//  Created by Jonny Sagorin on 12/2/12.
//  Copyright (c) 2012 RHoK. All rights reserved.
//

#import "IssueViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface IssueViewController ()
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *imageLabel;
@end

@implementation IssueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self components];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self style];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self data];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

-(void) style
{
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void) data
{
    self.navigationItem.title = self.incident.name;
    NSLog(@"%@", self.incident.imageUrl);
    if (self.incident.imageUrl) {
        [self.imageView setImageWithURL:[NSURL URLWithString:self.incident.imageUrl]];
    }
    
    self.imageLabel.text = [NSString stringWithFormat:@"%f, %f", self.incident.location.coordinate.longitude, self.incident.location.coordinate.latitude];
}

-(void)components
{
    self.imageView = [[UIImageView alloc]initWithImage:nil];
    self.imageView.frame = self.view.frame;
    [self.view addSubview:self.imageView];

    self.imageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - 44.0f - 20.0f,
                                                               self.view.frame.size.width, 20.0f)];
    self.imageLabel.textAlignment = NSTextAlignmentCenter;
    self.imageLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.imageLabel];

}
@end
