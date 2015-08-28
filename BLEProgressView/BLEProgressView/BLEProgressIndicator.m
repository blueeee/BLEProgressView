//
//  BLEProgressIndicator.m
//  BLEProgressView
//
//  Created by blueeee on 15-8-12.
//  Copyright (c) 2015年 blueeee. All rights reserved.
//

#import "BLEProgressIndicator.h"
@interface BLEProgressIndicator()<POPAnimationDelegate>
@property (nonatomic) CGFloat moveLength;
@property (nonatomic ,strong) CALayer *topLayer;
@property (nonatomic ,strong) CAShapeLayer *bottomLayer;

@property (nonatomic ,strong) UILabel *percentageLabel;

@property (nonatomic ,strong) CADisplayLink *displayLink;
@property (nonatomic ) CGFloat lastCenterX;
@property (nonatomic) CGFloat currentVelocity;
@end
#pragma mark - life cycle
@implementation BLEProgressIndicator

#pragma mark -
-(void)generateOriginalStyle{
    [super generateOriginalStyle];
    self.topLayer = [CALayer layer];
    self.topLayer.backgroundColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
    self.topLayer.position = CGPointMake(24, 15);
    self.topLayer.bounds = CGRectMake(0, 0, 24, 30);
    self.topLayer.cornerRadius = 2.f;
    [self.layer addSublayer:self.topLayer];
    
    self.bottomLayer = [CAShapeLayer layer];
    UIBezierPath *bottomBezierPath = [UIBezierPath bezierPath];
    [bottomBezierPath moveToPoint:CGPointMake(0, 28)];
    [bottomBezierPath addLineToPoint:CGPointMake(48, 28)];
    [bottomBezierPath addLineToPoint:CGPointMake(24, 60)];
    [bottomBezierPath closePath];
    self.bottomLayer.path = bottomBezierPath.CGPath;
    self.bottomLayer.fillColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
    [self.layer addSublayer:self.bottomLayer];
    
    self.layer.anchorPoint = CGPointMake(0.5, 1);
    self.moveLength = [UIScreen mainScreen].bounds.size.width-60;
}

-(void)generateReadyStyle{
    [super generateReadyStyle];
    [self startReadyStyleAnimation];
}

-(void)generateRunningStyle{
    [super generateRunningStyle];
    self.percentageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 28, 48, 25)];
    [self.percentageLabel setText:@"0%"];
    [self.percentageLabel setTextAlignment:NSTextAlignmentCenter];
    [self.percentageLabel setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [self.percentageLabel setFont:[UIFont fontWithName:@"CourierNewPS-BoldMT" size:13]];
    [self addSubview:self.percentageLabel];
    
    self.lastCenterX = 30;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getVelocity:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}
-(void)generateFailStyle{
    [super generateFailStyle];
    
    [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
     [self.layer pop_removeAnimationForKey:@"IndiRunStyleShakeAnim"];
    POPSpringAnimation *shakeAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    shakeAnim.toValue = @0;
    shakeAnim.springBounciness = 20;
    [self.layer pop_addAnimation:shakeAnim forKey:@"IndiFailStyleShakeToMidAnim"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        [self.percentageLabel setText:@"failed"];
        [self.percentageLabel setTextColor:[UIColor redColor]];
        [self.percentageLabel setFont:[UIFont fontWithName:@"CourierNewPS-BoldMT" size:10]];
        [self startFailStyleAnimationWithCompletion:^{
            self.progressState = BLEProgressStatefailed;
        }];
        
    });
}

-(void)generateResumeStyle{
    [super generateResumeStyle];
    [self startResumeStyleAnimWithCompletion:^{
        self.progressState = BLEProgressStateOringin;
    }];

}

-(void)setProgress:(CGFloat)progress{
    [super setProgress:progress];
    [self.percentageLabel setText:[NSString stringWithFormat:@"%d%%",(int)(100*progress)]];
    [self setCenter:CGPointMake(30+self.moveLength*progress, self.center.y)];
    if (progress == 1) {
        [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.layer pop_removeAnimationForKey:@"IndiRunStyleShakeAnim"];
        POPSpringAnimation *successShakeAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
        successShakeAnim.toValue = @0;
        successShakeAnim.springSpeed = 8;
        successShakeAnim.springBounciness = 18;
        [self.layer pop_addAnimation:successShakeAnim forKey:@"IndiSuccessStyleShakeAnim"];
        [successShakeAnim setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
            self.progressState = BLEProgressStateSuccess;
        }];
        
    }
}
#pragma mark - animation
-(void)startReadyStyleAnimation{
    //top
    POPBasicAnimation *topScaleAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerSize];
    topScaleAnim.toValue = [NSValue valueWithCGSize:CGSizeMake(40, 25)];
    topScaleAnim.duration = 0.5;
    [self.topLayer pop_addAnimation:topScaleAnim forKey:@"IndiReadyStyleTopScaleAnim"];
    
    POPBasicAnimation *topPositionAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    topPositionAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(24, 40)];
    topPositionAnim.duration = 0.5;
    [self.topLayer pop_addAnimation:topPositionAnim forKey:@"IndiReadyStyleTopPositionAnim"];
    
    POPBasicAnimation *topCornerAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    topCornerAnim.toValue = @3.f;
    topCornerAnim.duration = 0.5;
    [self.topLayer pop_addAnimation:topCornerAnim forKey:@"IndiReadyStyleTopCornerAnim"];
    
    //bottom
    POPBasicAnimation *bottomScaleAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    bottomScaleAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(0.25, 0.25)];
    bottomScaleAnim.duration = 0.5;
    [self.bottomLayer pop_addAnimation:bottomScaleAnim forKey:@"IndiReadyStyleTopScaleAnim"];
    
    POPBasicAnimation *bottomPositionAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    bottomPositionAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(18, 45)];
    bottomPositionAnim.duration = 0.5;
    [self.bottomLayer pop_addAnimation:bottomPositionAnim forKey:@"IndiReadyStyleBottomPositionAnim"];
    
    //all
    POPBasicAnimation *allPositionYAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    allPositionYAnim.toValue = @(18+30);
    allPositionYAnim.duration = 0.3;
    allPositionYAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    allPositionYAnim.name = @"IndiReadyStyleAllPositionYAnimIn";
    allPositionYAnim.delegate = self;
    [self.layer pop_addAnimation:allPositionYAnim forKey:@"IndiReadyStyleAllPositionYAnimIn"];
}

-(void)startFailStyleAnimationWithCompletion:(void(^)())completion{
    POPSpringAnimation *shakeAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    shakeAnim.toValue = @(M_PI*0.11);
    shakeAnim.springSpeed = 8;
    shakeAnim.springBounciness = 18;
    [self.layer pop_addAnimation:shakeAnim forKey:@"IndiFailStyleShakeAnim"];
    [shakeAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        if (completion) {
            completion();
        }
    }];

}

-(void)startResumeStyleAnimWithCompletion:(void(^)())completion{
    POPBasicAnimation *labelfakeAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    labelfakeAnim.toValue = @0;
    labelfakeAnim.duration = .5f;
    [self.percentageLabel pop_addAnimation:labelfakeAnim forKey:@"IndiResumeFadeAnim"];
    [labelfakeAnim setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
        [self.percentageLabel removeFromSuperview];
    }];
    
    POPBasicAnimation *shakeResumeAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    shakeResumeAnim.toValue = @0;
    shakeResumeAnim.duration = .3f;
    [self.layer pop_addAnimation:shakeResumeAnim forKey:@"IndiResumeShakeAnim"];
    [shakeResumeAnim setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
        //top
        POPBasicAnimation *topResumeScaleAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerSize];
        topResumeScaleAnim.toValue = [NSValue valueWithCGSize:CGSizeMake(24, 30)];
        topResumeScaleAnim.duration = 0.5;
        [self.topLayer pop_addAnimation:topResumeScaleAnim forKey:@"IndiResumeStyleTopScaleAnim"];
        
        POPBasicAnimation *topResumePositionAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
        topResumePositionAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(24, 15)];
        topResumePositionAnim.duration = 0.5;
        [self.topLayer pop_addAnimation:topResumePositionAnim forKey:@"IndiResumeStyleTopPositionAnim"];
        
        POPBasicAnimation *topResumeCornerAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
        topResumeCornerAnim.toValue = @2.f;
        topResumeCornerAnim.duration = 0.5;
        [self.topLayer pop_addAnimation:topResumeCornerAnim forKey:@"IndiResumeStyleTopCornerAnim"];
        
        //bottom
        POPBasicAnimation *bottomResumeScaleAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        bottomResumeScaleAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        bottomResumeScaleAnim.duration = 0.5;
        [self.bottomLayer pop_addAnimation:bottomResumeScaleAnim forKey:@"IndiResumeStyleTopScaleAnim"];
        
        POPBasicAnimation *bottomResumePositionAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
        bottomResumePositionAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
        bottomResumePositionAnim.duration = 0.5;
        [self.bottomLayer pop_addAnimation:bottomResumePositionAnim forKey:@"IndiResumeStyleBottomPositionAnim"];
        
        //all
        POPBasicAnimation *allResumePositionXAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        allResumePositionXAnim.toValue = @([UIScreen mainScreen].bounds.size.width/2);
        allResumePositionXAnim.duration = 0.5;
        [self.layer pop_addAnimation:allResumePositionXAnim forKey:@"IndiResumeStyleAllPositionXAnim"];
        
        POPBasicAnimation *allResumePositionYInAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        allResumePositionYInAnim.toValue = @40;
        allResumePositionYInAnim.duration = 0.3;
        allResumePositionYInAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.layer pop_addAnimation:allResumePositionYInAnim forKey:@"IndiResumeStyleAllPositionYAnimIn"];
        
        [allResumePositionYInAnim setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
            POPBasicAnimation *allResumePositionYOutAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
            allResumePositionYOutAnim.toValue = @90;
            allResumePositionYOutAnim.duration = 0.3;
            allResumePositionYOutAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            [self.layer pop_addAnimation:allResumePositionYOutAnim forKey:@"IndiResumeStyleAllPositionYAnimOut"];
            [allResumePositionXAnim setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
                if (completion) {
                    completion();
                }
            }];
        }];
        
    }];
    
    
}

#pragma mark - POPAnimationDelegate
-(void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished{
    if (finished) {
        if ([anim.name isEqualToString:@"IndiReadyStyleAllPositionYAnimIn"]) {
            //all
            POPBasicAnimation *allPositionYAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
            allPositionYAnim.name = @"IndiReadyStyleAllPositionYAnimOut";
            allPositionYAnim.toValue = @(26+30);
            allPositionYAnim.delegate = self;
            allPositionYAnim.duration = 0.3;
            allPositionYAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            [self.layer pop_addAnimation:allPositionYAnim forKey:@"IndiReadyStyleAllPositionYAnimOut"];
        }
        else if ([anim.name isEqualToString:@"IndiReadyStyleAllPositionYAnimOut"]) {
            POPBasicAnimation *shakeRightAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
            shakeRightAnim.toValue = @(M_PI*0.05);
            shakeRightAnim.duration = 0.05;
            shakeRightAnim.name = @"IndiReadyStyleShakeRightAnim";
            shakeRightAnim.delegate = self;
            [self.layer pop_addAnimation:shakeRightAnim forKey:@"IndiReadyStyleShakeRightAnim"];
            
        }
        else if ([anim.name isEqualToString:@"IndiReadyStyleShakeRightAnim"]) {
            
            POPBasicAnimation *moveAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
            moveAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(30, self.center.y)];
            moveAnim.duration = 0.4;
            moveAnim.name = @"IndiReadyStyleMoveAnim";
            moveAnim.delegate = self;
            [self pop_addAnimation:moveAnim forKey:@"IndiReadyStyleMoveAnim"];
        }
        else if ([anim.name isEqualToString:@"IndiReadyStyleMoveAnim"]){
            POPBasicAnimation *shakeLeftAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
            shakeLeftAnim.toValue = @(-M_PI*0.1);
            shakeLeftAnim.duration = 0.1;
            shakeLeftAnim.name = @"IndiReadyStyleShakeLeftAnim";
            shakeLeftAnim.delegate = self;
            [self.layer pop_addAnimation:shakeLeftAnim forKey:@"IndiReadyStyleShakeLeftAnim"];
        }
        else if ([anim.name isEqualToString:@"IndiReadyStyleShakeLeftAnim"]){
            POPSpringAnimation *shakeMidAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
            shakeMidAnim.toValue = @0;
            shakeMidAnim.springBounciness = 15;
            shakeMidAnim.name = @"IndiReadyStyleShakeMidAnim";
            shakeMidAnim.delegate = self;
            [self.layer pop_addAnimation:shakeMidAnim forKey:@"IndiReadyStyleShakeMidAnim"];
        }
        else if([anim.name isEqualToString:@"IndiReadyStyleShakeMidAnim"]){
            self.progressState = BLEProgressStateRunning;
        }
    }
}
#pragma mark - event response
-(void)getVelocity:(id)sender{
    if (self.progressState == BLEProgressStateRunning) {
        CGFloat velocity = (self.center.x - self.lastCenterX)/self.moveLength;
        if (velocity - self.currentVelocity >0.003) {
            ;
        }
        self.currentVelocity = velocity;
        POPSpringAnimation *shakeAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
        CGFloat factor = 0.2 < self.currentVelocity*10 ? 0.2:self.currentVelocity*10;
        shakeAnim.toValue = @(-M_PI*factor);
        NSLog(@"%f",self.currentVelocity);
        shakeAnim.springBounciness = 20;
        [self.layer pop_addAnimation:shakeAnim forKey:@"IndiRunStyleShakeAnim"];
        self.lastCenterX = self.center.x;

    }
}


@end
