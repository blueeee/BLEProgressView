//
//  ViewController.m
//  BLEProgressView
//
//  Created by blueeee on 15-8-12.
//  Copyright (c) 2015年 blueeee. All rights reserved.
//

#import "ViewController.h"
#import "BLEProgressView.h"
@interface ViewController ()
@property (nonatomic, strong) BLEProgressView *progressView;
@end

@implementation ViewController
#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addProgressView];
    
}

- (void)addProgressView{
    BLEProgressView *progressView = [[BLEProgressView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 120)];
    self.progressView = progressView;
    [self.view addSubview:progressView];
}
- (IBAction)start:(id)sender {
    [self.progressView start];
}
- (IBAction)error:(id)sender {
    [self.progressView fail];
}


@end
