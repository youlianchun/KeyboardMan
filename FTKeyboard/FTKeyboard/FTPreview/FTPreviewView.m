//
//  FTPreviewView.m
//  Demo
//
//  Created by YLCHUN on 2018/7/6.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "FTPreviewView.h"
#import "FTModels.h"
#import "FTCells.h"
#import "EmojiImage.h"

@implementation FTPreview
{
    UILongPressGestureRecognizer *_longPress;
    UICollectionView *_keyboard;
    UIView *_superview;
}

-(void)setup {
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressEvent:)];
    [_superview addGestureRecognizer:_longPress];
}

-(void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
}

- (void)lonePressEvent:(UILongPressGestureRecognizer *)longPress {
    switch (_longPress.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint p = [longPress locationInView:_keyboard];
            NSIndexPath *indexpath = [_keyboard indexPathForItemAtPoint:p];
            if (!indexpath) return;
            UICollectionViewCell<FTCellProtocol> *cell = (UICollectionViewCell<FTCellProtocol> *)[_keyboard cellForItemAtIndexPath:indexpath];
            if (!cell.data) return;
            self.center = [_keyboard convertPoint:cell.center toView:_superview];
            CGRect frame = self.frame;
            frame.origin.y -= (CGRectGetMidY(self.bounds) + CGRectGetMidY(cell.bounds));
            if (CGRectGetMinX(frame) < 0) {
                frame.origin.x = 0;
            }
            if (CGRectGetMaxX(frame) > CGRectGetMaxX(_keyboard.bounds)) {
                frame.origin.x = CGRectGetMaxX(_keyboard.bounds) - CGRectGetWidth(frame);
            }
            self.frame = frame;
            [self setData:cell.data];
            [self show];
        }break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:{
            [self hide];
        }break;
        default:
            break;
    }
}

- (void)setData:(FTData *)data {}

- (void)show
{
    [_superview addSubview:self];
}

- (void)hide {
    [self removeFromSuperview];
}

+ (instancetype)viewWithKeyboard:(UICollectionView *)keyboard superview:(UIView *)superview {
   FTPreview *preview = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    if (!preview) return nil;
    preview->_keyboard = keyboard;
    preview->_superview = keyboard.superview;
    [preview setup];
    return preview;
}


@end
@implementation FTSmallPreview
{
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UIImageView *_bgImageView;
}
-(void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = CGRectGetWidth(self.bounds)/2;
    
}
- (void)setData:(FTData *)data {
    UIImage *image = [data gifImg];
    if (!image) {
        image = [data pngImg];
    }
    _imageView.image = image;
}

@end


@implementation FTBigPreview
{
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UIImageView *_bgImageView;
}
-(void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    
}
- (void)setData:(FTData *)data {
    UIImage *image = [data gifImg];
    if (!image) {
        image = [data pngImg];
    }
    _imageView.image = image;
}



@end
