//
//  FTBigCell.m
//  Demo
//
//  Created by YLCHUN on 2018/7/6.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "FTCells.h"
#import "FTModels.h"

@implementation FTBigCell
{
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_label;
    __weak IBOutlet NSLayoutConstraint *_imageViewTop;
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

-(void)setData:(FTData *)data {
    if ([data isEqual:_data]) return;
    _data = data;
    UIImage *image;
    if (data.pngPath) {
        image = [data pngImg];
    }else {
        image = [data gifImg];
    }
    _imageView.image = image;
    if ([data.name isEqualToString:data.file]) {
        _label.text = nil;
        _imageViewTop.constant = 10;
    }else {
        _label.text = data.name;
        _imageViewTop.constant = 0;
    }
}

+(CGSize)size {
    return CGSizeMake(60, 80);
}
@end
