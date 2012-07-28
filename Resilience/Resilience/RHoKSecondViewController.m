//
//  RHoKSecondViewController.m
//  Resilience
//
//  Created by Daryl on 28/07/12.
//  Copyright (c) 2012 RHoK. All rights reserved.
//

#import "RHoKSecondViewController.h"

@interface RHoKSecondViewController ()

@end

@implementation RHoKSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
