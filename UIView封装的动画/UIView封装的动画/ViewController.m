//
//  ViewController.m
//  UIView封装的动画
//
//  Created by apple on 2016/11/24.
//  Copyright © 2016年 apple. All rights reserved.
//

/**
 动画主要分为如下的三种类型：
 1、隐式动画(Implicit Animation)：修改自己创建的图层（非根层）的属性时系统自动产生的动画，参考"ZPImplicitAnimation"Demo；
 2、核心动画(Core Animation)：使用抽象类CAAnimation中的各种子类来制作的动画，参考"ZPCABasicAnimation"等Demo；
 3、UIView封装的动画：
 （1）在修改UIView中的某些属性的代码前后加上其他代码而产生的动画效果；
 （2）调用UIView类中的封装好的设置动画的方法而产生的动画效果。
 上述的两种情况参考本Demo。
 */
#import "ViewController.h"

@interface ViewController () <CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) int currentIndex;

@end

@implementation ViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //核心动画
    [self coreAnimation];
    
    /**
     UIView封装的动画：
     */
    
    //（1）在修改UIView中的某些属性的代码前后加上其他代码而产生的动画效果（修改UIView类中的layer属性中的某些属性）。
//    [self UIViewPackagedAnimation];
    
    //（1）在修改UIView中的某些属性的代码前后加上其他代码而产生的动画效果（直接修改UIView类中的某些属性）。
//    [self UIViewPackagedAnimation1];
    
    //（2）调用UIView类中的封装好的设置动画的方法而产生的动画效果。
//    [self UIViewPackagedAnimation2];
}

#pragma mark ————— 核心动画 —————
/**
 使用核心动画实现的动画效果都是假象，并不会真实地改变图层的属性值。如果以后做动画的时候，在不需要与用户交互的地方（比如转场动画）可以使用核心动画来实现动画效果。
 */
- (void)coreAnimation
{
    NSLog(@"oldPosition = %@", NSStringFromCGPoint(self.imageView.layer.position));
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    
    animation.keyPath = @"position";
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(150, 400)];
    animation.duration = 2.0;
    animation.delegate = self;
    
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [self.testView.layer addAnimation:animation forKey:nil];
}

#pragma mark ————— CAAnimationDelegate —————
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"newPosition = %@", NSStringFromCGPoint(self.imageView.layer.position));
}

#pragma mark ————— UIView封装的动画 —————
/**
 与核心动画不同，UIView封装的动画是真实地改变了UIView的属性值；
 （1）在修改UIView中的某些属性的代码前后加上其他代码而产生的动画效果（修改UIView类中的layer属性中的某些属性值）。
 */
- (void)UIViewPackagedAnimation
{
    NSLog(@"oldPosition = %@", NSStringFromCGPoint(self.testView.layer.position));
    
    [UIView animateWithDuration:2 animations:^{
        self.testView.layer.position = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        NSLog(@"newPosition = %@", NSStringFromCGPoint(self.testView.layer.position));
    }];
}

/**
 （1）在修改UIView中的某些属性的代码前后加上其他代码而产生的动画效果（直接修改UIView类中的某些属性）。
 */
- (void)UIViewPackagedAnimation1
{
    NSLog(@"oldCenter = %@", NSStringFromCGPoint(self.testView.center));
    
    //第一种设置动画的方式：
//    [UIView beginAnimations:nil context:nil];
//    self.testView.center = CGPointMake(200, 300);
//    [UIView commitAnimations];
    
    //第二种设置动画的方式(block)：
    [UIView animateWithDuration:2.0 animations:^{
        self.testView.center = CGPointMake(200, 300);
    } completion:^(BOOL finished) {
        NSLog(@"动画执行完毕");
    }];
    
    NSLog(@"newCenter = %@", NSStringFromCGPoint(self.testView.center));
}

/**
 （2）调用UIView类中的封装好的设置动画的方法而产生的动画效果。
 */
- (void)UIViewPackagedAnimation2
{
    self.currentIndex++;

    if (self.currentIndex == 9)
    {
        self.currentIndex = 0;
    }

    NSString *imageName = [NSString stringWithFormat:@"%d.jpg", self.currentIndex + 1];
    self.imageView.image = [UIImage imageNamed:imageName];

    [UIView transitionWithView:self.imageView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:^(BOOL finished) {
        NSLog(@"动画执行完毕");
    }];
}

@end
