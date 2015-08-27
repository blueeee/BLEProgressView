//
//  BLEProgressView.h
//  BLEProgressView
//
//  Created by blueeee on 15-8-12.
//  Copyright (c) 2015年 blueeee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLEProgressView : UIView
- (instancetype)initWithFrame:(CGRect)frame;
-(void)start;
-(void)fail;
-(void)setProgess:(CGFloat)progress;
@end
