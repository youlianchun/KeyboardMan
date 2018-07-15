//
//  TextInput+BKeyboard.h
//  BKeyboard
//
//  Created by YLCHUN on 2018/7/9.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <UIKit/UITextView.h>
#import <UIKit/UITextField.h>
#import "ns_import.h"
@class BKeyboard;

@interface UITextView (BKeyboard)
@property (nonatomic, strong) BKeyboard *bKeyboard;
-(void)change2DefKeyboard;
-(void)change2BKeyboard;
@end

@interface UITextField (BKeyboard)
@property (nonatomic, strong) BKeyboard *bKeyboard;
-(void)change2DefKeyboard;
-(void)change2BKeyboard;
@end

#define NS_IMPORT_TextInputBKeyboard TextInputBKeyboard

NS_IMPORT_EXTERN(NS_IMPORT_TextInputBKeyboard);
