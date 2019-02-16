//
//  BKeyboardController.h
//  BKeyboard
//
//  Created by YLCHUN on 2018/7/4.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bk_import.h"

@interface BKeyboardController : UIViewController
- (BOOL)hasText NS_REQUIRES_SUPER;
- (void)insertText:(NSString *)text NS_REQUIRES_SUPER;
- (void)deleteBackward NS_REQUIRES_SUPER;
- (void)cleanText NS_REQUIRES_SUPER;
@end


@protocol BKeyboardControllerInput <NSObject>
@property(nonatomic, strong) __kindof BKeyboardController *bKeyboardController;
@property(nonatomic, readonly) BOOL usedBKeyboard;
- (void)useDefKeyboard;
- (void)useBKeyboard;
@end

@interface UITextView (BKeyboardController)<BKeyboardControllerInput>
@end

@interface UITextField (BKeyboardController)<BKeyboardControllerInput>
@end

#define BK_IMPORT_TextInputBKeyboard TextInputBKeyboard

BK_IMPORT_EXTERN(BK_IMPORT_TextInputBKeyboard);

