//
//  BKeyboard.h
//  KeyboardControl
//
//  Created by YLCHUN on 2018/7/4.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//
//  Blank Keyboard

#import <Foundation/Foundation.h>

@class UIView;
@class UIViewController;

@interface BKeyboard : NSObject
@property(nonatomic, readonly) UIView *view;
@property(nonatomic, strong) __kindof UIViewController *rootViewController;
- (instancetype)initWithHeight:(NSUInteger)height NS_DESIGNATED_INITIALIZER;
- (void)show NS_REQUIRES_SUPER;
- (void)hide NS_REQUIRES_SUPER;
+ (BOOL)endEditing:(BOOL)force;
@end

