//
//  UINavigationController+ATProxy.h
//  ATProxy
//
//  Created by YLCHUN on 2018/7/14.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATProxyImport.h"

@interface UINavigationController (ATProxy)

-(void)pushViewController:(UIViewController *)viewController transitional:(id <UIViewControllerAnimatedTransitioning>)transitional;

-(UIViewController *)popViewControllerTransitional:(id <UIViewControllerAnimatedTransitioning>)transitional;
-(NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController transitional:(id <UIViewControllerAnimatedTransitioning>)transitional;
-(NSArray<UIViewController *> *)popToRootViewControllerTtransitional:(id <UIViewControllerAnimatedTransitioning>)transitional;

@end

#define AT_IMPORT_UINavigationController_ATProxy UINavigationController_ATProxy
AT_IMPORT_EXTERN(AT_IMPORT_UINavigationController_ATProxy);
