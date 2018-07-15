//
//  FTMenuCell.m
//  Demo
//
//  Created by YLCHUN on 2018/7/6.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "FTCells.h"
#import "FTModels.h"
@implementation FTMenuCell
{
    __weak IBOutlet UIImageView *_imageView;
    NSString *_title;
    __weak IBOutlet UIView *_lineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    // Initialization code
}

-(void)didMoveToSuperview {
    if (_lineView.backgroundColor) return;
    _lineView.backgroundColor = self.superview.superview.backgroundColor;
}

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = _lineView.backgroundColor;
    }else {
        self.backgroundColor = self.superview.backgroundColor;
    }
}

- (void)setData:(FTBundles *)data {
    if (_title && [data.title isEqualToString:_title]) return;
    _imageView.image = data.icon;
}

+(CGSize)size {
    return CGSizeMake(45, 35);
}
@end
