//
//  FTAttachment.m
//  Demo
//
//  Created by YLCHUN on 2018/7/9.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "FTAttachment.h"
#import <UIKit/UIKit.h>
#import "FTModels.h"

NSString *const kFTAttachmentText = @"kFTAttachmentText";
@implementation FTAttachmentText
{
    NSAttributedString *_textAttributed;
}
@synthesize data = _data;

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_data forKey:@"data"];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _data = [aDecoder decodeObjectForKey:@"data"];
    }
    return self;
}

+(instancetype)textWithData:(FTData *)data {
    FTAttachmentText *text = [FTAttachmentText new];
    text->_data = data;
    return text;
}

-(NSAttributedString *)imageAttributedWithFont:(UIFont *)font isGif:(BOOL)isGif {
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
    textAttachment.image = isGif ? [self.data gifImg] : [self.data pngImg];
    CGFloat imageHeight = font.lineHeight + 2;
    CGFloat imageWidth = imageHeight / textAttachment.image.size.height *textAttachment.image.size.width;
    textAttachment.bounds = CGRectMake(0, font.descender, imageWidth, imageHeight);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
    [attributedString addAttribute:kFTAttachmentText value:self range:NSMakeRange(0, attributedString.length)];
    return [attributedString copy];
}

-(NSAttributedString *)textAttributed {
    if (_textAttributed) return _textAttributed;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:_data.key]];
    [attributedString addAttribute:kFTAttachmentText value:self range:NSMakeRange(0, attributedString.length)];
    _textAttributed = [attributedString copy];
    return _textAttributed;
}

+(NSAttributedString *)convertAttributedString:(NSAttributedString *)string convert:(NSAttributedString *(^)(FTAttachmentText *text))convert {
    if (!convert) return string;
    NSMutableAttributedString *mAStr = [string mutableCopy];
    [mAStr enumerateAttribute:kFTAttachmentText inRange:NSMakeRange(0, mAStr.length) options:kNilOptions usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (![value isKindOfClass:[FTAttachmentText class]]) return;
        FTAttachmentText *text = value;
        NSAttributedString *aStr = convert(text);
        [mAStr replaceCharactersInRange:range withAttributedString:aStr];
    }];
    return [mAStr copy];
}

@end




@implementation FTAttachmentRange
@synthesize aText = _aText;
@synthesize range = _range;

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_range.location forKey:@"location"];
    [aCoder encodeInteger:_range.length forKey:@"length"];
    [aCoder encodeObject:_aText forKey:@"aText"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        NSUInteger location = [aDecoder decodeIntegerForKey:@"location"];
        NSUInteger length = [aDecoder decodeIntegerForKey:@"length"];
        _range = NSMakeRange(location, length);
        _aText = [aDecoder decodeObjectForKey:@"aText"];
    }
    return self;
}

+(void)resolveAttributedString:(NSAttributedString *)aString callback:(void(^)(NSArray<FTAttachmentRange*> *attachmentRanges, NSString *string))callback {
    if (!callback || aString.length == 0) return;
    NSMutableArray *arr = [NSMutableArray array];
    [aString enumerateAttribute:kFTAttachmentText inRange:NSMakeRange(0, aString.length) options:kNilOptions usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (![value isKindOfClass:[FTAttachmentText class]]) return;
        FTAttachmentRange *aRange = [FTAttachmentRange new];
        aRange->_range = range;
        aRange->_aText = value;
        [arr addObject:aRange];
    }];
    callback([arr copy], aString.string);
}

+(NSAttributedString *)composeAttributedString:(NSArray<FTAttachmentRange*> *)attachmentRanges string:(NSString *)string {
    NSMutableAttributedString *mAStr = [[NSMutableAttributedString alloc] initWithString:string];
    for (FTAttachmentRange *range in attachmentRanges) {
        [mAStr addAttribute:kFTAttachmentText value:range.aText range:range.range];
    }
    return [mAStr copy];
}

@end
