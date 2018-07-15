//
//  FTKeyboardController.h
//  Demo
//
//  Created by YLCHUN on 2018/7/5.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FTData;
@protocol FTKeyboardControllerDelegate <NSObject>
- (void)didSelectedFTData:(FTData *)data isText:(BOOL)isText;
@end

@class FTBundles;
@interface FTKeyboardController : UICollectionViewController
-(instancetype)initWithData:(FTBundles *)data delegate:(id<FTKeyboardControllerDelegate>)delegate;
@end

@interface FTKeyboardCell : UICollectionViewCell
-(void)createKeyboard:(FTKeyboardController *(^)(void))callback;
@end
