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
    //初始
    BLEProgressStateOringin = 0,
    //进度条生成
    BLEProgressStateReady,
    //进度条执行
    BLEProgressStateRunning,
    //完成即100%
    BLEProgressStateSuccess,
    //失败动画中
    BLEProgressStatefailAnim,
    //失败
    BLEProgressStatefailed,
    //恢复到初始状态
    BLEProgressStateResume
} ProgressState;

@property (nonatomic, assign) ProgressState progressState;
@property (nonatomic, assign) CGFloat currentProgress;
@property (nonatomic, weak) id<BLEProgressBaseViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate;

-(void)originate;
-(void)start;
-(void)run;
-(void)fail;
-(void)resume;

-(void)generateOriginalStyle;
-(void)generateReadyStyle;
-(void)generateRunningStyle;
-(void)generateFailStyle;
-(void)generateResumeStyle;

-(void)setProgress:(CGFloat)progress;

@end
@protocol BLEProgressBaseViewDelegate<NSObject>
@optional
-(void)progressView :(BLEProgressBaseView*)progressView changedState:(ProgressState)state;

@end