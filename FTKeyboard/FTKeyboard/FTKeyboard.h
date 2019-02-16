//
//  FTKeyboard.h
//  Demo
//
//  Created by YLCHUN on 2018/7/5.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <BlankKeyboard/BlankKeyboard.h>
#import <UIKit/UITextView.h>
@class FTData;
@protocol FTKeyInput <NSObject>
- (void)outputFace:(FTData *)data;
- (void)insertFace:(FTData *)data;
- (void)insertReturn;
- (void)insertDelete;
@end

@interface FTKeyboard : BKeyboard
@property (nonatomic, readonly) UIView *view NS_UNAVAILABLE;
@property(nonatomic, strong) UIViewController *rootViewController NS_UNAVAILABLE;
-(instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithHeight:(NSUInteger)height NS_UNAVAILABLE;
-(instancetype)initWithDelegate:(id<FTKeyInput>)delegate NS_DESIGNATED_INITIALIZER;
@end

@interface FTTextView : UITextView
@property (nullable, readwrite, strong) UIView *inputView NS_UNAVAILABLE;

@end

