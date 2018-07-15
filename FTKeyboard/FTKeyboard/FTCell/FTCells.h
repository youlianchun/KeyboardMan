//
//  FTBaseCell.h
//  Demo
//
//  Created by YLCHUN on 2018/7/6.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTData, FTBundles;

@protocol FTBaseCollectionProtocol<NSObject>
@property (class, readonly) NSString *identifier;
+(void)registerToCollectionView:(UICollectionView *)collectionView;
+(instancetype)collectionView:(UICollectionView *)collectionView dequeueReusableAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol FTCellProtocol<NSObject>
@property (nonatomic, readonly) FTData *data;
@property (nonatomic, readonly) UIImage *image;
- (void)setData:(FTData *)data;
@end

@interface FTBaseNibCell : UICollectionViewCell <FTBaseCollectionProtocol>
@property (class, readonly) CGSize size;
@end

@interface FTSmallCell : FTBaseNibCell<FTCellProtocol>
@property (nonatomic, readonly) BOOL isEmoji;
@end

@interface FTBigCell : FTBaseNibCell <FTCellProtocol>
@end

@interface FTMenuCell : FTBaseNibCell
- (void)setData:(FTBundles *)data;
@end

@interface FTSmallCellHead : UICollectionReusableView<FTBaseCollectionProtocol>
- (void)setData:(NSString *)data;
+ (CGSize)sizeAtFirst:(BOOL)first;
@end

