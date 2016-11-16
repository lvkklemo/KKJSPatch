//
//  ViewController.m
//  KKJsPatch
//
//  Created by 宇航 on 16/11/10.
//  Copyright © 2016年 KH. All rights reserved.
//

#import "ViewController.h"
#import "ABTableViewController.h"
#import "MyAlertView.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50)];
    [btn setTitle:@"Push ABTableViewController" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:btn];
    
}

- (void)handleBtn:(id)sender{

//   ABTableViewController * ab = [[ABTableViewController alloc]init];
    
//    [self.navigationController pushViewController:ab animated:YES];
    
//   MyAlertView * myl = [[MyAlertView alloc] initWithTitle:@"提示" andContent:@"示提jjkjkkjkjkjkjjkjjkoi0909o123456" CancelButton:@"calcel" OkButton:@"OKBUtton" andTextViewType:@"123" andPlaceHolder:@"andPlaceHolder"];
//    [myl show];
//    [self.view addSubview:myl];
}

@end
