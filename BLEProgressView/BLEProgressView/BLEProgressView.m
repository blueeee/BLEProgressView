//
//  BLEProgressView.m
//  BLEProgressView
//
//  Created by blueeee on 15-8-12.
//  Copyright (c) 2015年 blueeee. All rights reserved.
//

#import "BLEProgressView.h"

@interface BLEProgressView()<BLEProgressBaseViewDelegate>
@property (nonatomic, strong) BLEProgressBar *progressBar;
@property (nonatomic, strong) BLEProgressIndicator *progressIndicator;


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
    self.progressBar = [[BLEProgressBar alloc]initWithFrame:CGRectMake(0, 0, 96, 120) delegate:self];
    [self.progressBar originate];
    self.progressBar.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addSubview:self.progressBar];
}
-(void)addIndicator{
    self.progressIndicator = [[BLEProgressIndicator alloc]initWithFrame:CGRectMake(0, 0, 48, 60) delegate:self];
    [self.progressIndicator originate];
    self.progressIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+30);
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
    
}

-(void)resume{
    if (self.progressIndicator.progressState == BLEProgressStatefailed && self.progressBar.progressState == BLEProgressStatefailed){
        [self.progressBar resume];
        [self.progressIndicator resume];
    }
    else if (self.progressIndicator.progressState == BLEProgressStateSuccess && self.progressBar.progressState == BLEProgressStateSuccess){
        [self.progressBar resume];
        [self.progressIndicator resume];
    }
}

-(void)fail{
    
    if (self.progressIndicator.progressState == BLEProgressStateRunning && self.progressBar.progressState == BLEProgressStateRunning){
        
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
    else if (self.progressIndicator.progressState ==BLEProgressStatefailed && self.progressBar.progressState == BLEProgressStatefailAnim) {
        self.progressBar.progressState = BLEProgressStatefailed;
        return;
    }
    
    if (self.progressBar.progressState == BLEProgressStateOringin && self.progressIndicator.progressState == BLEProgressStateOringin) {
        if ([self.delegate respondsToSelector:@selector(progressView:didChangedState:)]) {
            [self.delegate progressView:self didChangedState:BLEProgressStateOringin];
        }
        
    }
    else if(self.progressBar.progressState == BLEProgressStateReady && self.progressIndicator.progressState == BLEProgressStateReady){
        if ([self.delegate respondsToSelector:@selector(progressView:didChangedState:)]) {
            [self.delegate progressView:self didChangedState:BLEProgressStateReady];
        }
        
    }
    else if(self.progressBar.progressState == BLEProgressStateRunning && self.progressIndicator.progressState == BLEProgressStateRunning){
        [self run];
        if ([self.delegate respondsToSelector:@selector(progressView:didChangedState:)]) {
            [self.delegate progressView:self didChangedState:BLEProgressStateRunning];
        }
        
    }
    else if(self.progressBar.progressState == BLEProgressStateSuccess && self.progressIndicator.progressState == BLEProgressStateSuccess){
        if ([self.delegate respondsToSelector:@selector(progressView:didChangedState:)]) {
            [self.delegate progressView:self didChangedState:BLEProgressStateSuccess];
        }
        
    }
    else if(self.progressBar.progressState == BLEProgressStatefailAnim && self.progressIndicator.progressState == BLEProgressStatefailAnim){
        if ([self.delegate respondsToSelector:@selector(progressView:didChangedState:)]) {
            [self.delegate progressView:self didChangedState:BLEProgressStatefailAnim];
        }
        
    }
    else if(self.progressBar.progressState == BLEProgressStatefailed && self.progressIndicator.progressState == BLEProgressStatefailed){
        if ([self.delegate respondsToSelector:@selector(progressView:didChangedState:)]) {
            [self.delegate progressView:self didChangedState:BLEProgressStatefailed];
        }
        
    }
    else if(self.progressBar.progressState == BLEProgressStateResume && self.progressIndicator.progressState == BLEProgressStateResume){
        if ([self.delegate respondsToSelector:@selector(progressView:didChangedState:)]) {
            [self.delegate progressView:self didChangedState:BLEProgressStateResume];
        }
        
    }
   
    
}
#pragma mark - event response


#pragma mark - setter and getter
-(void)setDelegate:(id<BLEProgressViewDelegate>)delegate{
    _delegate = delegate;
    if ([_delegate respondsToSelector:@selector(progressView:didChangedState:)]) {
        [_delegate progressView:self didChangedState:BLEProgressStateOringin];
    }
}
@end
