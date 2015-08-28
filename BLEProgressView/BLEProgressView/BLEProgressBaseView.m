//
//  BLEProgressBaseView.m
//  BLEProgressView
//
//  Created by blueeee on 15-8-13.
//  Copyright (c) 2015年 blueeee. All rights reserved.
//

#import "BLEProgressBaseView.h"
@interface BLEProgressBaseView()

@end
@implementation BLEProgressBaseView
#pragma mark - life cycle
+(instancetype)progressViewWithFrame:(CGRect)frame{
    return [[BLEProgressBaseView alloc]initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    self.delegate = delegate;
    return self;
}
#pragma mark -
-(void)generateOriginalStyle{
    self.progressState = BLEProgressStateOringin;
}

-(void)generateReadyStyle{
    self.progressState = BLEProgressStateReady;
}

-(void)generateRunningStyle{
    self.progressState = BLEProgressStateRunning;
}

-(void)generateFailStyle{
    self.progressState = BLEProgressStatefailAnim;
}

-(void)generateResumeStyle{
    self.progressState = BLEProgressStateResume;
}

-(void)setProgress:(CGFloat)progress{
    self.currentProgress = progress;
}
#pragma mark - 
-(void)originate{
    [self generateOriginalStyle];
}

-(void)start{
    [self generateReadyStyle];
}
-(void)run{
    [self generateRunningStyle];
}
-(void)fail{
    [self generateFailStyle];
}
-(void)resume{
    [self generateResumeStyle];
}
#pragma mark - getter and setter
-(void)setProgressState:(ProgressState)progressState{
    if (!_progressState || _progressState != progressState) {
        _progressState = progressState;
        if ([self.delegate respondsToSelector:@selector(progressView:changedState:)]) {
            [self.delegate progressView:self changedState:progressState];
        }
    }
    
    
}
@end
