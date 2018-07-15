//
//  ViewController.m
//  KeyboardMan
//
//  Created by YLCHUN on 2018/7/9.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import "ViewController.h"
#import <BKeyboard/Keyboard.h>

@interface ViewController ()
{
    BKeyboard *_keyboard;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _keyboard = [self newBKeyboard];
    [self observeNotification];
}

-(BKeyboard *)newBKeyboard {
    UIButton *keyBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [keyBtn setTitle:@"按键" forState:UIControlStateNormal];
    [keyBtn addTarget:self action:@selector(keyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    keyBtn.backgroundColor = [UIColor orangeColor];
    BKeyboard *bKeyboard = [BKeyboard new];
    [bKeyboard.view addSubview:keyBtn];
    return bKeyboard;
}

-(void)keyBtnAction:(UIButton *)sender {
    NSLog(@"%s", __func__);
}

-(void)observeNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)bKeyboardShow:(id)sender {
    [_keyboard show];
}

- (IBAction)bKeyboardHide:(id)sender {
    [_keyboard hide];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSLog(@"%s", __func__);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSLog(@"%s", __func__);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [BKeyboard endEditing:NO];
}

@end
