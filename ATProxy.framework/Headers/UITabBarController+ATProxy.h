//
//  UITabBarController+ATProxy.h
//  ATProxy
//
//  Created by YLCHUN on 2018/7/14.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATProxyImport.h"

@interface UITabBarController (ATProxy)

- (void)setSelectedIndex:(NSUInteger)selectedIndex transition:(id <UIViewControllerAnimatedTransitioning>)transition;

- (void)setSelectedViewController:(UIViewController *)selectedViewController transition:(id <UIViewControllerAnimatedTransitioning>)transition;

@end

#define AT_IMPORT_UITabBarController_ATProxy UITabBarController_ATProxy
AT_IMPORT_EXTERN(AT_IMPORT_UITabBarController_ATProxy);
