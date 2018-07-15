//
//  FTKeyboardController.m
//  Demo
//
//  Created by YLCHUN on 2018/7/5.
//  Copyright © 2018年 ylchun. All rights reserved.
//  FaceTheme

#import "FTKeyboardController.h"
#import "FTCells.h"
#import "FTModels.h"
#import "FTPreviewView.h"

@interface FTKeyboardController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    FTBundles *_data;
    FTPreview *_previewView;
    __weak id<FTKeyboardControllerDelegate> _delegate;
}
@end

@implementation FTKeyboardController

-(instancetype)initWithData:(FTBundles *)data delegate:(id<FTKeyboardControllerDelegate>)delegate {
    if (self = [super initWithCollectionViewLayout:[UICollectionViewFlowLayout new]]) {
        _data = data;
        _delegate = delegate;
    }
    return self;
}

-(void)setupCollectionView
{
    self.collectionView.backgroundColor = [UIColor clearColor];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.collectionViewLayout;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    if (_data.isText) {
        [FTSmallCell registerToCollectionView:self.collectionView];
        [FTSmallCellHead registerToCollectionView:self.collectionView];
        flowLayout.itemSize = FTSmallCell.size;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 8, 5, 8);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
    }else {
        [FTBigCell registerToCollectionView:self.collectionView];
        flowLayout.itemSize = FTBigCell.size;
        NSUInteger space = (CGRectGetWidth(self.view.bounds)  - 4 * flowLayout.itemSize.width) / 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(15, space, 15, space);
        flowLayout.minimumInteritemSpacing = space;
        flowLayout.minimumLineSpacing = 5;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    [self setupPreview];
    [self.collectionView reloadData];
}

- (void)setupPreview {
    if (_data.isText) {
        _previewView = [FTSmallPreview viewWithKeyboard:self.collectionView superview:self.view];
    }else {
        _previewView = [FTBigPreview viewWithKeyboard:self.collectionView superview:self.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell <FTCellProtocol> *cell;
    if (_data.isText) {
        cell = [FTSmallCell collectionView:collectionView dequeueReusableAtIndexPath:indexPath];
    }else {
        cell = [FTBigCell collectionView:collectionView dequeueReusableAtIndexPath:indexPath];
    }
    FTData *data = _data.datas[indexPath.section].datas[indexPath.row];
    [cell setData:data];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _data.datas[section].datas.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _data.datas.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FTData *data = _data.datas[indexPath.section].datas[indexPath.row];
    [_delegate didSelectedFTData:data isText:_data.isText];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (!_data.isText || [kind isEqualToString:UICollectionElementKindSectionFooter]) return [UICollectionReusableView new];
    FTSmallCellHead *head = [FTSmallCellHead collectionView:collectionView dequeueReusableAtIndexPath:indexPath];
    [head setData:_data.datas[indexPath.section].name];
    return head;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (!_data.isText) return CGSizeZero;
    if (_data.datas.count < 2 || _data.datas[section].datas.count == 0) return CGSizeZero;
    return [FTSmallCellHead sizeAtFirst:section == 0];
}

@end


@implementation FTKeyboardCell
{
    FTKeyboardController *_controller;
}

-(void)createKeyboard:(FTKeyboardController *(^)(void))callback {
    if (!_controller) {
        _controller = callback();
        _controller.view.frame = self.contentView.bounds;
        [self.contentView addSubview:_controller.view];
        _controller.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
}

@end
