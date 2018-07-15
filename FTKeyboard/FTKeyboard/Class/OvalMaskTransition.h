//
//  OvalMaskTransition.h
//  Transition
//
//  Created by YLCHUN on 2018/7/10.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <ATProxy/ATProxy.h>

@interface OvalMaskTransition : NSObject<UIViewControllerAnimatedTransitioning>
-(instancetype)initWithOperation:(UINavigationControllerOperation)operation timeInterval:(NSTimeInterval)timeInterval anchor:(CGPoint)anchor;
@end
