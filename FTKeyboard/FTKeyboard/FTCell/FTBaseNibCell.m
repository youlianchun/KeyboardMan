//
//  FTBaseCell.m
//  Demo
//
//  Created by YLCHUN on 2018/7/6.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "FTCells.h"

@implementation FTBaseNibCell

+(NSString*) identifier {
    return NSStringFromClass([self class]);
}

+(void)registerToCollectionView:(UICollectionView *)collectionView {
    UINib *nib = [UINib nibWithNibName:self.identifier bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:self.identifier];
}

+(instancetype)collectionView:(UICollectionView *)collectionView dequeueReusableAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:self.identifier forIndexPath:indexPath];
}

+(CGSize)size {
    return CGSizeZero;
}
@end
