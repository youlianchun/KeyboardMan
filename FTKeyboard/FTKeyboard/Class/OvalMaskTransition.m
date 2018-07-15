//
//  OvalMaskTransition.m
//  Transition
//
//  Created by YLCHUN on 2018/7/10.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import "OvalMaskTransition.h"

@interface OvalMaskTransition ()<CAAnimationDelegate>
@end

@implementation OvalMaskTransition {
    id <UIViewControllerContextTransitioning> _transitionContext;
    CGPoint _anchor;
    UIView *_maskView;
    UINavigationControllerOperation _operation;
    NSTimeInterval _timeInterval;
}

-(instancetype)initWithOperation:(UINavigationControllerOperation)operation timeInterval:(NSTimeInterval)timeInterval anchor:(CGPoint)anchor {
    if (self = [super init]) {
        _operation = operation;
        _timeInterval = timeInterval;
        _anchor = anchor;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return _timeInterval;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    _transitionContext = transitionContext;
    UIView *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    to.frame = from.bounds;
    UIView *containerView = transitionContext.containerView;
    switch (_operation) {
        case UINavigationControllerOperationPush:
            [self pushInContainer:containerView from:from to:to];
            break;
        case UINavigationControllerOperationPop:
            [self popInContainer:containerView from:from to:to];
            break;
        default:
            break;
    }
}

- (void)animationEnded:(BOOL) transitionCompleted {
    _maskView.layer.mask = nil;
}

- (void)pushInContainer:(UIView *)containerView from:(UIView *)from to:(UIView *)to {
    [containerView addSubview:from];
    [containerView addSubview:to];
    
    [self transitionPathWithRect:from.bounds callback:^(CGPathRef min, CGPathRef max) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = min;
        to.layer.mask = layer;
        CABasicAnimation *animation = [self transitionAnimationFrom:min to:max];
        [layer addAnimation:animation forKey:@"spread"];
        self->_maskView = to;
    }];
}

- (void)popInContainer:(UIView *)containerView from:(UIView *)from to:(UIView *)to {
    [containerView addSubview:to];
    [containerView addSubview:from];
    
    [self transitionPathWithRect:from.bounds callback:^(CGPathRef min, CGPathRef max) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = max;
        from.layer.mask = layer;
        CABasicAnimation *animation = [self transitionAnimationFrom:max to:min];
        [layer addAnimation:animation forKey:@"converge"];
        self->_maskView = from;
    }];
}

-(CGFloat)radiusWithRect:(CGRect)rect point:(CGPoint)point {
    CGFloat x, y;
    if (point.x > CGRectGetMidX(rect)) {
        x = point.x - CGRectGetMinX(rect);
    }else {
        x = point.x - CGRectGetMaxX(rect);
    }
    if (point.y > CGRectGetMidY(rect)) {
        y = point.y - CGRectGetMinY(rect);
    }else {
        y = point.y - CGRectGetMaxY(rect);
    }
    return sqrt(x * x + y * y);
}

-(void)transitionPathWithRect:(CGRect)rect callback:(void(^)(CGPathRef min, CGPathRef max))callback {
    if (!callback) return;
    CGRect minRect = CGRectZero;
    minRect.origin = _anchor;
    CGFloat radius = [self radiusWithRect:rect point:_anchor];
    CGRect maxRect = CGRectInset(minRect, -radius, -radius);
    UIBezierPath *minPath = [UIBezierPath bezierPathWithOvalInRect:minRect];
    UIBezierPath *maxPath = [UIBezierPath bezierPathWithOvalInRect:maxRect];
    callback(minPath.CGPath, maxPath.CGPath);
}

-(CABasicAnimation *)transitionAnimationFrom:(CGPathRef)from to:(CGPathRef)to {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id)(from);
    animation.toValue = (__bridge id)(to);
    animation.duration = [self transitionDuration:_transitionContext];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    return animation;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [_transitionContext completeTransition:!_transitionContext.transitionWasCancelled];
}


+(instancetype)alloc {
    NSLog(@"%s", __func__);
    return [super alloc];
}
-(void)dealloc {
    NSLog(@"%s", __func__);
}

@end


