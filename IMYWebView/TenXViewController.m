//
//  TenXViewController.m
//  IMYWebView
//
//  Created by grx on 2018/8/17.
//  Copyright © 2018年 grx. All rights reserved.
//

#import "TenXViewController.h"

@interface TenXViewController ()

@end

@implementation TenXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLoadWithTitle:@"腾讯首页" url:@"https://www.baidu.com"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
