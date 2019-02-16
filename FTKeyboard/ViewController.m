//
//  ViewController.m
//  Demo
//
//  Created by YLCHUN on 2018/7/4.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "ViewController.h"
#import "FTKeyboard.h"
#import "EmojiImage.h"

@interface ViewController ()
{
    __weak IBOutlet FTTextView *_textView;
    __weak IBOutlet UIImageView *_imageView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self observeNotification];
    _imageView.image = emojiImage(@"😊", 60);
}

-(void)observeNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)change2BKeyboard:(id)sender {
    [_textView useBKeyboard];
}

- (IBAction)change2DefKeyboard:(id)sender {
    [_textView useDefKeyboard];
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
