//
//  FTPreviewView.h
//  Demo
//
//  Created by YLCHUN on 2018/7/6.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTPreview : UIView
+ (instancetype)viewWithKeyboard:(UICollectionView *)keyboard superview:(UIView *)superview;
@end

@interface FTSmallPreview : FTPreview
@end
@interface FTBigPreview : FTPreview
@end
