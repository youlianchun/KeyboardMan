//
//  FTSmallCell.m
//  Demo
//
//  Created by YLCHUN on 2018/7/6.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "FTCells.h"
#import "FTModels.h"

@implementation FTSmallCell
{
    __weak IBOutlet UIImageView *_imageView;
    FTData *_data;
}
@synthesize data = _data;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(UIImage *)image {
    return _imageView.image;
}

-(BOOL)isEmoji {
    return _imageView.hidden;
}

- (void)setData:(FTData *)data {
    if ([data isEqual:_data]) return;
    _data = data;
    _imageView.image = [_data pngImg];
}


+(CGSize)size {
    return CGSizeMake(40, 40);
}
@end
