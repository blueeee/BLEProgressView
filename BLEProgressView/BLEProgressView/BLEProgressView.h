//
//  BLEProgressView.h
//  BLEProgressView
//
//  Created by blueeee on 15-8-12.
//  Copyright (c) 2015年 blueeee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEProgressBar.h"
#import "BLEProgressIndicator.h"
@class BLEProgressView;
@protocol BLEProgressViewDelegate<NSObject>
@optional
-(void)progressView :(BLEProgressView*)progressView didChangedState:(ProgressState)state;

@end
@interface BLEProgressView : UIView

@property (nonatomic ,weak) id<BLEProgressViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

-(void)start;
-(void)fail;
-(void)resume;
-(void)setProgess:(CGFloat)progress;

@end
