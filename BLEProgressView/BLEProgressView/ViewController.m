//
//  ViewController.m
//  BLEProgressView
//
//  Created by blueeee on 15-8-12.
//  Copyright (c) 2015年 blueeee. All rights reserved.
//

#import "ViewController.h"
#import "BLEProgressView.h"

float progress = 0;

@interface ViewController ()<BLEProgressViewDelegate>
@property (nonatomic, strong) BLEProgressView *progressView;
@property (nonatomic, strong) CADisplayLink* displayLink;
@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addProgressView];
    
}

- (void)addProgressView{
    BLEProgressView *progressView = [[BLEProgressView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 120)];
    self.progressView = progressView;
    self.progressView.delegate = self;
    [self.view addSubview:progressView];
}

#pragma mark - event response

- (IBAction)start:(id)sender {
    [self.progressView start];
}
- (IBAction)error:(id)sender {
    if (progress != 0) {
        [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        progress = 0;
    }
    
    [self.progressView fail];
}
- (IBAction)resume:(id)sender {
    [self.progressView resume];
}

-(void)setProgress:(id)sender{
    if (progress > 100.f) {
        [self.progressView setProgess:1];
        [sender removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        progress = 0;
        return;
    }
    [self.progressView setProgess:progress/100.f];
    if (progress<10) {
        progress += 1;
    }
    else if (progress>=10 && progress <20) {
        progress += 1;
    }
    else if (progress>=20 && progress <30) {
        progress += 0.2;
    }
    else if (progress>=30 && progress <40) {
        progress += 0.2;
    }
    else if (progress>=40 && progress <50) {
        progress += 1.5;
    }
    else if (progress>=50 && progress <60) {
        progress += 1.5;
    }
    else if (progress>=60 && progress <70) {
        progress += 1.5;
    }
    else if (progress>=70 && progress <80) {
        progress += 1.5;
    }
    else if (progress>=80 && progress <90) {
        progress += 1.5;
    }
    else {
        progress += 1.5;
    }
}

#pragma mark - BLEProgressViewDelegate
-(void)progressView:(BLEProgressView *)progressView didChangedState:(ProgressState)state{
    if (state == BLEProgressStateRunning) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(setProgress:) ];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}
@end
