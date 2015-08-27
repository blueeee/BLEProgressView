//
//  BLEProgressBaseView.h
//  BLEProgressView
//
//  Created by blueeee on 15-8-13.
//  Copyright (c) 2015年 blueeee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <POP.h>
@protocol BLEProgressBaseViewDelegate;

@interface BLEProgressBaseView:UIView

typedef enum BLEProgressState{
    BLEProgressStateOringin = 0,
    BLEProgressStateReady,
    BLEProgressStateRunning,
    BLEProgressStateSuccess,
    BLEProgressStatefailed
} ProgressState;

@property (nonatomic, assign) ProgressState progressState;
@property (nonatomic, assign) CGFloat currentProgress;
@property (nonatomic, weak) id<BLEProgressBaseViewDelegate> delegate;

-(void)start;
-(void)run;
-(void)fail;
-(void)resume;

-(void)generateOriginalStyle;
-(void)generateReadyStyle;
-(void)generateRunningStyle;
-(void)generateFailStyle;

-(void)setProgress:(CGFloat)progress;

@end
@protocol BLEProgressBaseViewDelegate<NSObject>
@optional
-(void)progressView :(BLEProgressBaseView*)progressView changedState:(ProgressState)state;

@end