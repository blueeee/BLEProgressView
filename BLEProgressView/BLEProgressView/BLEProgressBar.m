//
//  BLEProgressBar.m
//  BLEProgressView
//
//  Created by blueeee on 15-8-12.
//  Copyright (c) 2015年 blueeee. All rights reserved.
//

#import "BLEProgressBar.h"
@interface BLEProgressBar()
@property (nonatomic) CGFloat barLength;
@property (nonatomic ,strong) CAShapeLayer *loadlayer;
@property (nonatomic ,strong) CAShapeLayer *triangleLayer;
@property (nonatomic, strong) UIBezierPath *bezierPath;

@end

@implementation BLEProgressBar
#pragma mark -
-(void)generateOriginalStyle{
    [super generateOriginalStyle];
    self.layer.backgroundColor = [UIColor colorWithRed:21.0/255.0 green:53.0/255.0 blue:74.0/255.0 alpha:1.f].CGColor;
    self.layer.cornerRadius = 6.f;
    self.barLength = [UIScreen mainScreen].bounds.size.width-52;
}

-(void)generateReadyStyle{
    [super generateReadyStyle];
    [self startReadyStyleAnimation];
}

-(void)generateRunningStyle{
    [super generateRunningStyle];
    if (!self.loadlayer ) {
        self.loadlayer = [CAShapeLayer layer];
        [self.loadlayer setFillColor:[UIColor whiteColor].CGColor];
        [self.layer addSublayer:self.loadlayer];
    }
}

-(void)generateFailStyle{
    [super generateFailStyle];
    
    CAShapeLayer *triangleLayer = [CAShapeLayer layer];
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake((self.barLength-8)*self.currentProgress+10, 8)];
    [trianglePath addLineToPoint:CGPointMake((self.barLength-8)*self.currentProgress+5, 8)];
    [trianglePath addLineToPoint:CGPointMake((self.barLength-8)*self.currentProgress+7.5, 3)];
    [trianglePath closePath];
    triangleLayer.path = trianglePath.CGPath;
    [triangleLayer setFillColor:[UIColor colorWithRed:52.0/255.0 green:157.0/255.0 blue:243.0/255.0 alpha:1].CGColor];
    [self.layer addSublayer:triangleLayer];
//    [self.layer insertSublayer:triangleLayer below:self.loadlayer];
    self.triangleLayer = triangleLayer;
    
    [self startFailStyleEmitterAnimationWithCompletion:^{

        [self startFailStyleLoadBarDismissAnimation];
    }];

    
}

-(void)setProgress:(CGFloat)progress{
    [super setProgress:progress];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 8.f, 8.f) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(4.f, 4.f)];
    UIBezierPath *bezierPathNew = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(8.f, 0, (self.barLength-8)*progress, 8.f) byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(4.f, 4.f)];
    [bezierPath appendPath:bezierPathNew];
    self.loadlayer.path = [bezierPath CGPath];

}
#pragma mark - animation
-(void)startReadyStyleAnimation{
    POPBasicAnimation *cornerAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    cornerAnim.toValue = @4.f;
    cornerAnim.duration= 0.5f;
    [self.layer pop_addAnimation:cornerAnim forKey:@"BarReadyStyleCornerAnim"];
    POPBasicAnimation *sizeAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerSize];
    sizeAnim.toValue = [NSValue valueWithCGSize:CGSizeMake(self.barLength, 8)];
    sizeAnim.duration = 0.5f;
    [self.layer pop_addAnimation:sizeAnim forKey:@"BarReadyStyleSizeAnim"];
}
-(void)startFailStyleEmitterAnimationWithCompletion:(void(^)())completion{
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = CGRectMake((self.barLength-8)*self.currentProgress, 8, 1, 1);
    [self.layer addSublayer:emitter];
    
    emitter.backgroundColor =  [UIColor colorWithRed:21.0/255.0 green:53.0/255.0 blue:74.0/255.0 alpha:1.f].CGColor;
    emitter.emitterShape = kCAEmitterLayerRectangle;
    emitter.renderMode = kCAEmitterLayerBackToFront;
    emitter.emitterMode = kCAEmitterLayerSurface;
    
    CAEmitterCell *leftCell = [[CAEmitterCell alloc] init];
    CAEmitterCell *rightCell = [[CAEmitterCell alloc] init];
    
    CGSize imageSize = CGSizeMake(0.8, 0.8);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [[UIColor colorWithRed:21.0/255.0 green:53.0/255.0 blue:74.0/255.0 alpha:1.f] set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    leftCell.contents = (__bridge id)image.CGImage;
    leftCell.birthRate = 2;
    leftCell.lifetime = 1.0;
    leftCell.velocity = 30;
    leftCell.emissionRange = M_PI/10;
    leftCell.emissionLongitude = M_PI/8*3;
    
    rightCell.contents = (__bridge id)image.CGImage;
    rightCell.birthRate = 2;
    rightCell.lifetime = 1.0;
    rightCell.velocity = 30;
    rightCell.emissionRange = M_PI/10;
    rightCell.emissionLongitude = M_PI/8*5;
    
    emitter.emitterCells = @[leftCell,rightCell];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        
        [emitter removeFromSuperlayer];
        if (completion) {
            completion();
        }
        
    });
}
-(void)startFailStyleLoadBarDismissAnimation{
    CALayer *downLayer = [CALayer layer];
    downLayer.anchorPoint = CGPointMake(0, 0);
    downLayer.position = CGPointMake((self.barLength-8)*self.currentProgress+5, 6);
    downLayer.bounds = CGRectMake(0, 0, 5, 0);
    [downLayer setBackgroundColor:[UIColor whiteColor].CGColor];
    downLayer.cornerRadius = 2.5f;
    [self.layer addSublayer:downLayer];
    
    POPBasicAnimation *sizeDownAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerSize];
    sizeDownAnim.duration = 2.4f;
    sizeDownAnim.toValue = [NSValue valueWithCGSize:CGSizeMake(0, (self.currentProgress*(self.barLength-8)+8)*2)];
    [downLayer pop_addAnimation:sizeDownAnim forKey:@"BarFailStyleSizeDownAnim"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        
        POPBasicAnimation *downAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        downAnim.duration = 1.2f;
        downAnim.toValue = @300;
        [downLayer pop_addAnimation:downAnim forKey:@"BarFailStyleDownAnim"];
        [downAnim setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
            [downLayer removeFromSuperlayer];
        }];
    
    });
    
    
    POPBasicAnimation *positionYAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionYAnim.duration = 1.2f;
    positionYAnim.toValue = @8;
    [self.loadlayer pop_addAnimation:positionYAnim forKey:@"BarFailStylePositionYAnim"];
    
    POPBasicAnimation *scaleYAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleY];
    scaleYAnim.duration = 1.2f;
    scaleYAnim.toValue = @0;
    [self.loadlayer pop_addAnimation:scaleYAnim forKey:@"BarFailStyleScaleYAnim"];
    
    
}
@end
