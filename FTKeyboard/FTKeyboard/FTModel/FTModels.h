//
//  FTGIFImage.h
//  Demo
//
//  Created by YLCHUN on 2018/7/6.
//  Copyright © 2018年 ylchun. All rights reserved.
//


#import <Foundation/Foundation.h>
@class UIImage;

@interface FTData : NSObject<NSCoding>
@property (nonatomic, readonly) NSString *gifPath;
@property (nonatomic, readonly) NSString *pngPath;
@property (nonatomic, readonly) NSString *file;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *key;
-(BOOL)isEqual:(FTData *)object;
-(UIImage *)gifImg;
-(UIImage *)pngImg;
- (BOOL)isEmoji;
@end

@interface FTBundle : NSObject
@property (nonatomic, readonly)BOOL isText;
@property (nonatomic, readonly)NSString *name;
@property (nonatomic, readonly)UIImage *icon;
@property(nonatomic, readonly)NSArray<FTData *> *datas;
@end

@interface FTBundles : NSObject
@property (nonatomic, readonly)BOOL isText;
@property (nonatomic, readonly)NSString *title;
@property (nonatomic, readonly)UIImage *icon;
@property(nonatomic, readonly)NSArray<FTBundle *> *datas;
+(NSArray<FTBundles *> *)loadBundles;
@end

