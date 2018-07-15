//
//  FTAttachment.h
//  Demo
//
//  Created by YLCHUN on 2018/7/9.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage, UIFont, FTData;

extern NSString *const kFTAttachmentText;

@interface FTAttachmentText : NSObject<NSCoding>
@property (nonatomic, readonly) FTData *data;
-(NSAttributedString *)imageAttributedWithFont:(UIFont *)font isGif:(BOOL)isGif;
-(NSAttributedString *)textAttributed;

+(instancetype)textWithData:(FTData *)data;

+(NSAttributedString *)convertAttributedString:(NSAttributedString *)string convert:(NSAttributedString *(^)(FTAttachmentText *text))convert;
@end



@interface FTAttachmentRange : NSObject
@property (nonatomic, readonly) NSRange range;
@property (nonatomic, readonly) FTAttachmentText *aText;

+(void)resolveAttributedString:(NSAttributedString *)aString callback:(void(^)(NSArray<FTAttachmentRange*> *attachmentRanges, NSString *string))callback;
+(NSAttributedString *)composeAttributedString:(NSArray<FTAttachmentRange*> *)attachmentRanges string:(NSString *)string;
@end
