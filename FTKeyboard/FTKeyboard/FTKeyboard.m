//
//  FTKeyboard.m
//  Demo
//
//  Created by YLCHUN on 2018/7/5.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "FTKeyboard.h"
#import "FTKCController.h"
#import "FTAttachment.h"
#import "FTModels.h"

@interface _BKNavigationController : UINavigationController
@end

@implementation _BKNavigationController
{
    UIView *_lineView;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.subviews.firstObject.clipsToBounds = NO;
    self.navigationBarHidden = YES;
    self.view.clipsToBounds = NO;
    [self setupLineView];
}

-(void)setupLineView {
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self.view insertSubview:_lineView atIndex:0];
    _lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_lineView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_lineView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_lineView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [_lineView addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.5]];
}
@end

@interface FTKeyboard()<FTKCControllerDelegate>
@end

@implementation FTKeyboard
{
    __weak id<FTKeyInput> _delegate;
}
@dynamic view;

-(instancetype)initWithDelegate:(id<FTKeyInput>)delegate {
    if (self = [super initWithHeight:230]) {
        _delegate = delegate;
        [self setup];
    }
    return self;
}

-(void)setup {
    FTKCController *controller = [[FTKCController alloc] initWithDelegate:self];
    _BKNavigationController *navController = [[_BKNavigationController alloc] initWithRootViewController:controller];
    super.rootViewController = navController;
}

-(void)didSelectedFTData:(FTData *)data isText:(BOOL)isText {
    if (isText) {
        [_delegate insertFace:data];
    }else {
        [_delegate outputFace:data];
    }
}

-(void)didSelectedReturnKey {
    [_delegate insertReturn];
    [self hide];
}

-(void)didSelectedDeleteKey {
    [_delegate insertDelete];
}
@end


@interface FTTextView()<FTKeyInput>
@end
@implementation FTTextView

@dynamic inputView;

-(instancetype)init {
    return [self initWithFrame:CGRectZero];
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setupKeyboard];
    return self;
}

-(void)awakeFromNib {
    [self setupKeyboard];
    [super awakeFromNib];
}

-(void)setupKeyboard {
    if (self.bKeyboard) return;
    self.bKeyboard = [[FTKeyboard alloc] initWithDelegate:self];
}

- (BOOL)resignFirstResponder {
    [self change2DefKeyboard];
    return [super resignFirstResponder];
}

-(void)replaceInSelectedRange:(NSAttributedString *)attachmentString {
    NSRange selectedRange = self.selectedRange;
    NSMutableAttributedString *string = [self.attributedText mutableCopy];
    [string replaceCharactersInRange:selectedRange withAttributedString:attachmentString];
    self.attributedText = string;
    self.selectedRange = NSMakeRange(selectedRange.location + attachmentString.length, 0);
}

-(void)outputFace:(FTData *)data {
    
}

-(void)insertFace:(FTData *)data {
    NSAttributedString *aStr;
    if ([data isEmoji]) {
        aStr = [[NSAttributedString alloc] initWithString:data.name];
    }else {
        FTAttachmentText *text = [FTAttachmentText textWithData:data];
        aStr = [text imageAttributedWithFont:super.font isGif:NO];
    }
    [self replaceInSelectedRange:aStr];
    
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
}


- (void)insertReturn {
    NSAttributedString *aStr = [[NSAttributedString alloc] initWithString:@"\n"];
    [self replaceInSelectedRange:aStr];
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
}

- (void)insertDelete {
    [self deleteBackward];
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
}


//粘贴板
- (void)cut:(id)sender {
    [self copy:sender];
    [self deleteBackward];
}

- (void)copy:(id)sender {
    NSAttributedString *aStr = [self.attributedText attributedSubstringFromRange:self.selectedRange];
    
    aStr = [FTAttachmentText convertAttributedString:aStr convert:^NSAttributedString *(FTAttachmentText *text) {
        return [text textAttributed];
    }];
    NSLog(@"%@", aStr.string);
    [FTAttachmentRange resolveAttributedString:aStr callback:^(NSArray<FTAttachmentRange *> *attachmentRanges, NSString *string) {
        NSMutableData *data = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:attachmentRanges forKey:@"attachmentRanges"];
        [archiver encodeObject:string forKey:@"content"];
        [archiver finishEncoding];
        [[UIPasteboard generalPasteboard] setData:data forPasteboardType:@"AttributedString"];
    }];
}

- (void)paste:(id)sender {
    NSData *data = [[UIPasteboard generalPasteboard] dataForPasteboardType:@"AttributedString"];
    [[UIPasteboard generalPasteboard] setData:[NSData data] forPasteboardType:@"AttributedString"];
    if (data.length == 0) return;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSArray *attachmentRanges = [unarchiver decodeObjectForKey:@"attachmentRanges"];
    NSString *string = [unarchiver decodeObjectForKey:@"content"];
    NSAttributedString *aStr = [FTAttachmentRange composeAttributedString:attachmentRanges string:string];
    aStr = [FTAttachmentText convertAttributedString:aStr convert:^NSAttributedString *(FTAttachmentText *text) {
        return [text imageAttributedWithFont:self.font isGif:NO];
    }];
    [self replaceInSelectedRange:aStr];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    //TODO:优化粘贴选项
    BOOL b = [super canPerformAction:action withSender:sender];
    if (action == @selector(paste:)) {
        NSMutableData *data = [[[UIPasteboard generalPasteboard] dataForPasteboardType:@"AttributedString"] mutableCopy];
        if (data.length > 0) {
            b = YES;
        }
    }
    return b;
}

//拖拽粘贴
//-(BOOL)canPasteItemProviders:(NSArray<NSItemProvider *> *)itemProviders {
//    return YES;
//}
//-(void)pasteItemProviders:(NSArray<NSItemProvider *> *)itemProviders {
//
//}

-(NSString *)text {
    if (super.attributedText.length > 0) {
        return [FTAttachmentText convertAttributedString:super.attributedText convert:^NSAttributedString *(FTAttachmentText *text) {
            return [text textAttributed];
        }].string;
    }
    return [super text];
}

@end
