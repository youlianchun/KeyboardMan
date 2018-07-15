//
//  FTKCController.m
//  Demo
//
//  Created by YLCHUN on 2018/7/5.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "FTKCController.h"
#import "FTKeyboardController.h"
#import "FTModels.h"
#import "FTCells.h"
#import "FTSettingController.h"
#import "OvalMaskTransition.h"

@interface FTKCController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, FTKeyboardControllerDelegate>
{
    IBOutlet UICollectionView *_keyboardCollectionView;
    IBOutlet UICollectionView *_menuCollectionView;
    NSArray<FTBundles *>*_datas;
    NSIndexPath *_currentIndexPath;
    id<FTKCControllerDelegate> _delegate;
    
    IBOutlet NSLayoutConstraint *_returnBtnRight;
    IBOutlet UIButton *_returnBtn;
    IBOutlet UIButton *_deleteBtn;
    IBOutlet UIButton *_settingBtn;
}
@end

@implementation FTKCController

-(instancetype) initWithDelegate:(id<FTKCControllerDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _datas = [FTBundles loadBundles];
    _currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    for (FTBundles *data in _datas) {
        [_keyboardCollectionView registerClass:[FTKeyboardCell class] forCellWithReuseIdentifier:data.title];
    }
    
    [FTMenuCell registerToCollectionView:_menuCollectionView];
    
    [_keyboardCollectionView reloadData];
    [_menuCollectionView reloadData];

    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeReturnBtn:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != _keyboardCollectionView) return;
    NSUInteger menuRow = (scrollView.contentOffset.x + CGRectGetWidth(scrollView.bounds)/2)/CGRectGetWidth(scrollView.bounds);
    menuRow = MIN(menuRow, _datas.count-1);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    [self collectionView:nil didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:menuRow inSection:0]];
#pragma clang diagnostic pop
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _keyboardCollectionView) {
        FTKeyboardCell *cell = (FTKeyboardCell *)[collectionView dequeueReusableCellWithReuseIdentifier:_datas[indexPath.row].title forIndexPath:indexPath];
        [cell createKeyboard:^FTKeyboardController *{
            return [[FTKeyboardController alloc] initWithData:self->_datas[indexPath.row] delegate:self];
        }];
        return cell;
    }
    
    FTMenuCell *cell = [FTMenuCell collectionView:collectionView dequeueReusableAtIndexPath:indexPath];
    [cell setData:_datas[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _keyboardCollectionView) return;
    cell.selected = [indexPath isEqual:_currentIndexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _keyboardCollectionView) {
        return collectionView.bounds.size;
    }
    return [FTMenuCell size];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _datas.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _keyboardCollectionView) return;
    if ([indexPath isEqual:_currentIndexPath]) return;
    if (collectionView) {//didscroll触发
        [_keyboardCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    collectionView = _menuCollectionView;
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    BOOL needChangeReturnBtn = _datas[_currentIndexPath.row].isText ||  _datas[indexPath.row].isText;
    _currentIndexPath = indexPath;
    [self changeReturnBtn:needChangeReturnBtn];
    [collectionView reloadData];
}

-(void)changeReturnBtn:(BOOL)need {
    if (!need) return;
    BOOL isText = _datas[_currentIndexPath.row].isText;
    CGFloat rRight = isText ? 0 : -CGRectGetWidth(_returnBtn.bounds);
    CGFloat sAlpha = isText ? 0 : 1;
    [UIView animateWithDuration:0.14 animations:^{
        self->_returnBtnRight.constant = rRight;
        self->_settingBtn.alpha = sAlpha;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        CGFloat inset = CGRectGetWidth(self->_menuCollectionView.frame) - CGRectGetMinX(self->_deleteBtn.frame);
        self->_menuCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, inset);
    }];
}

-(void)didSelectedFTData:(FTData *)data isText:(BOOL)isText {
    [[UIDevice currentDevice] playInputClick];
    [_delegate didSelectedFTData:data isText:isText];
}

- (IBAction)returnBtnAction:(UIButton *)sender {
    [_delegate didSelectedReturnKey];
}

- (IBAction)settingBtnAction:(UIButton *)sender {
    OvalMaskTransition *transition = [[OvalMaskTransition alloc] initWithOperation:UINavigationControllerOperationPush timeInterval:0.5 anchor:sender.center];
    FTSettingController *controller = [FTSettingController new];
    [self.navigationController pushViewController:controller transitional:transition];
}

- (IBAction)deleteBtnAction:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [_delegate didSelectedDeleteKey];
}

@end

