//
//  FTSmallCellHead.m
//  Demo
//
//  Created by YLCHUN on 2018/7/6.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "FTCells.h"

@implementation FTSmallCellHead
{
    __weak IBOutlet UILabel *_label;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(NSString *)data {
    _label.text = data;
}

+(NSString*) identifier {
    return NSStringFromClass([self class]);
}

+(void)registerToCollectionView:(UICollectionView *)collectionView {
    UINib *nib = [UINib nibWithNibName:self.identifier bundle:nil];
    [collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:self.identifier];
}

+(instancetype)collectionView:(UICollectionView *)collectionView dequeueReusableAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:self.identifier forIndexPath:indexPath];
}

+ (CGSize)sizeAtFirst:(BOOL)first; {
    return CGSizeMake(0, first ? 28:18);
}
@end
