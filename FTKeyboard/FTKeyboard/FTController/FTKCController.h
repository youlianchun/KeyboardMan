//
//  FTKCController.h
//  Demo
//
//  Created by YLCHUN on 2018/7/6.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FTData;
@protocol FTKCControllerDelegate <NSObject>

- (void)didSelectedFTData:(FTData *)data isText:(BOOL)isText;

-(void)didSelectedReturnKey;
-(void)didSelectedDeleteKey;
@end

@interface FTKCController : UIViewController
-(instancetype) initWithDelegate:(id<FTKCControllerDelegate>)delegate;
@end
