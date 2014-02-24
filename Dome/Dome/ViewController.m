//
//  ViewController.m
//  Dome
//
//  Created by Lei on 14-2-24.
//  Copyright (c) 2014年 Lei. All rights reserved.
//

#import "ViewController.h"
#import "GLLockManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setPassword:(id)sender {
    [[GLLockManager Share] setPassword];
}

- (IBAction)enterpasseord:(id)sender {
    [[GLLockManager Share] enterPasswd];
    
}
- (IBAction)resetPassword:(id)sender {
    [[GLLockManager Share] ResetPasswd];
    
}

@end
