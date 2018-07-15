//
//  FTSettingController.m
//  FTKeyboard
//
//  Created by YLCHUN on 2018/7/10.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import "FTSettingController.h"
#import "OvalMaskTransition.h"

@interface FTSettingController ()
@end

@implementation FTSettingController
{
    __weak IBOutlet UIButton *_closeBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(UIView *)closeBtn {
    return _closeBtn;
}

- (IBAction)closeBtnAction:(UIButton *)sender {
    OvalMaskTransition *transition = [[OvalMaskTransition alloc] initWithOperation:UINavigationControllerOperationPop timeInterval:0.5 anchor:sender.center];
    [self.navigationController popViewControllerTransitional:transition];
}
@end

