//
//  ViewController.m
//  Objectc-Hello-world-NoStoryBoard
//
//  Created by 彭熙 on 2020/12/29.
//  Copyright © 2020 彭熙@lirawx.cn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.text = @"Hello, world!";
    
    [self.view addSubview: label];
}


@end
