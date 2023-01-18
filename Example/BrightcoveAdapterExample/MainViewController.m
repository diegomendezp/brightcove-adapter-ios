//
//  MainViewController.m
//  VideoCloudBasicPlayer
//
//  Created by Joan on 29/07/16.
//  Copyright © 2016 Brightcove. All rights reserved.
//

#import "MainViewController.h"
@import YouboraConfigUtils;

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showConfigClicked:(id)sender {
    YouboraConfigViewController *vc = [YouboraConfigViewController initFromXIBWithAnimatedNavigation:true];
    [[self navigationController] pushViewController:vc animated:true];
}

@end
