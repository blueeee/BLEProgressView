//
//  BLEProgressView.m
//  BLEProgressView
//
//  Created by blueeee on 15-8-12.
//  Copyright (c) 2015年 blueeee. All rights reserved.
//

#import "BLEProgressView.h"
#import "BLEProgressBar.h"
#import "BLEProgressIndicator.h"
@interface BLEProgressView()<BLEProgressBaseViewDelegate>
@property (nonatomic, strong) BLEProgressBar *progressBar;
@property (nonatomic, strong) BLEProgressIndicator *progressIndicator;

@property (nonatomic, strong) CADisplayLink* displayLink;
@end
@implementation BLEProgressView
#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addProgressBar];
        [self addIndicator];
    }
    return self;
}

-(void)addProgressBar{
    self.progressBar = [[BLEProgressBar alloc]initWithFrame:CGRectMake(0, 0, 96, 120)];
    self.progressBar.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.progressBar.delegate = self;
    [self addSubview:self.progressBar];
}
-(void)addIndicator{
    self.progressIndicator = [[BLEProgressIndicator alloc]initWithFrame:CGRectMake(0, 0, 48, 60)];
    self.progressIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+30);
    self.progressIndicator.delegate = self;
    [self addSubview:self.progressIndicator];
}
#pragma mark -
-(void)start{
    if (self.progressIndicator.progressState == BLEProgressStateOringin && self.progressBar.progressState == BLEProgressStateOringin) {
        [self.progressBar start];
        [self.progressIndicator start];
    }
    
}

-(void)run{
    [self.progressBar run];
    [self.progressIndicator run];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(display:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

}
-(void)fail{
    
    if (self.progressIndicator.progressState == BLEProgressStateRunning && self.progressBar.progressState == BLEProgressStateRunning){
        [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.progressBar fail];
        [self.progressIndicator fail];
    }
}
-(void)setProgess:(CGFloat)progress{
    [self.progressBar setProgress:progress];
    [self.progressIndicator setProgress:progress];
    
}
#pragma mark - BLEProgressBaseViewDelegate
-(void)progressView:(BLEProgressBaseView *)progressView changedState:(ProgressState)state{
    if (self.progressIndicator.progressState == BLEProgressStateRunning && self.progressBar.progressState == BLEProgressStateReady) {
        self.progressBar.progressState = BLEProgressStateRunning;
        return;
    }
    if (self.progressBar.progressState == BLEProgressStateRunning && self.progressIndicator.progressState == BLEProgressStateRunning) {
        [self run];
    }
}
#pragma mark - event response
-(void)display:(id)sender{
    static float i = 0.f;
    if (i > 100.f) {
        [self setProgess:1];
        [sender removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        return;
    }
    [self setProgess:i/100.f];
    if (i<10) {
        i += 1;
    }
    else if (i>=10 && i <20) {
        i += 1;
    }
    else if (i>=20 && i <30) {
        i += 0.2;
    }
    else if (i>=30 && i <40) {
        i += 0.2;
    }
    else if (i>=40 && i <50) {
        i += 1.5;
    }
    else if (i>=50 && i <60) {
        i += 1.5;
    }
    else if (i>=60 && i <70) {
        i += 1.5;
    }
    else if (i>=70 && i <80) {
        i += 1.5;
    }
    else if (i>=80 && i <90) {
        i += 1.5;
    }
    else {
        i += 1.5;
    }
}
@end
