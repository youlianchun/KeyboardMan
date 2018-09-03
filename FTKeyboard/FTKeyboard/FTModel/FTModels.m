//
//  FTGIFImage.m
//  Demo
//
//  Created by YLCHUN on 2018/7/6.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "FTModels.h"
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

static float frameDuration(NSUInteger index, CGImageSourceRef source) {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp != nil) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp != nil) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    CFRelease(cfFrameProperties);
    return frameDuration;
}


static UIImage *gifFromData(NSData * data) {
    if (!data) return nil;
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage;
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        NSTimeInterval duration = 0.0f;
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            duration += frameDuration(i, source);
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CGImageRelease(image);
        }
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    CFRelease(source);
    return animatedImage;
}


@interface FTCache:NSObject
@end
static FTCache *ftCache;
@implementation FTCache
{
    NSCache *_cache;
}
+(UIImage*)imageForKey:(NSString*)key get:(UIImage*(^)(NSString*key))get {
    UIImage *image = [[FTCache cache] imageForKey:key];
    if (!image) {
        image = get(key);
        [[FTCache cache] setImage:image forKey:key];
    }
    return image;
}

+(instancetype)cache {
    if (!ftCache) {
        ftCache = [[FTCache alloc] init];
    }
    return ftCache;
}
-(instancetype)init {
    self = [super init];
    if (self) {
        _cache = [[NSCache alloc] init];
    }
    return self;
}
- (UIImage *)imageForKey:(NSString *)key {
    return [_cache objectForKey:key];
}
- (void)setImage:(UIImage*)image forKey:(NSString*)key {
    [_cache setObject:image forKey:key];
}

@end

@interface FTData ()
@property (nonatomic, copy) NSString *file;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *dir;
@end

@implementation FTData
@synthesize gifPath = _gifPath;
@synthesize pngPath = _pngPath;

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _dir = [aDecoder decodeObjectForKey:@"dir"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _key =  [aDecoder decodeObjectForKey:@"key"];
        _file = [aDecoder decodeObjectForKey:@"fileName"];
        _gifPath = [aDecoder decodeObjectForKey:@"gifPath"];
        _pngPath = [aDecoder decodeObjectForKey:@"pngPath"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_dir forKey:@"dir"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_key forKey:@"key"];
    [aCoder encodeObject:_file forKey:@"fileName"];
    [aCoder encodeObject:_gifPath forKey:@"gifPath"];
    [aCoder encodeObject:_pngPath forKey:@"pngPath"];
}

-(BOOL)isEqual:(FTData *)object {
    return [object.file isEqual:_file] && [object.name isEqual:_name];
}

static bool hasFile(NSString *file) {
    return [[NSFileManager defaultManager] fileExistsAtPath:file];
}

-(NSString *)pngPath {
    if (_pngPath) return _pngPath;
    NSString *file = [_dir stringByAppendingPathComponent:[_file stringByAppendingString:@"fix.png"]];
    if (hasFile(file)) {
        _pngPath = file;
        return _pngPath;
    }
    file = [_dir stringByAppendingPathComponent:[_file stringByAppendingString:@"fix@2x.png"]];
    if (hasFile(file)) {
        _pngPath = file;
        return _pngPath;
    }
    return nil;
}

-(NSString *)gifPath {
    if (_gifPath) return _gifPath;
    NSString *file = [_dir stringByAppendingPathComponent:[_file stringByAppendingString:@".gif"]];
    if (hasFile(file)) {
        _gifPath = file;
        return _gifPath;
    }
    file = [_dir stringByAppendingPathComponent:[_file stringByAppendingString:@"@2x.gif"]];
    if (hasFile(file)) {
        _gifPath = file;
        return _gifPath;
    }
    return nil;
}

- (BOOL)isEmoji {
    if (_name.length > 2 || _name.length == 0) return NO;
    BOOL isEomji = NO;
    const unichar hs = [_name characterAtIndex:0];
    // surrogate pair
    if (0xd800 <= hs && hs <= 0xdbff) {
        if (_name.length > 1) {
            const unichar ls = [_name characterAtIndex:1];
            const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
            if (0x1d000 <= uc && uc <= 0x1f77f) {
                isEomji = YES;
            }
        }
    } else {
        // non surrogate
        if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
            isEomji = YES;
        } else if (0x2B05 <= hs && hs <= 0x2b07) {
            isEomji = YES;
        } else if (0x2934 <= hs && hs <= 0x2935) {
            isEomji = YES;
        } else if (0x3297 <= hs && hs <= 0x3299) {
            isEomji = YES;
        } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
            isEomji = YES;
        }
        if (!isEomji && _name.length > 1) {
            const unichar ls = [_name characterAtIndex:1];
            if (ls == 0x20e3) {
                isEomji = YES;
            }
        }
    }
    return isEomji;
}

-(UIImage *)gifImg {
    if (self.gifPath) {
        return [FTCache imageForKey:_gifPath get:^UIImage *(NSString *key) {
            return gifFromData([NSData dataWithContentsOfFile:key]);
        }];
    }
    if (self.pngPath) {
        return [FTCache imageForKey:_pngPath get:^UIImage *(NSString *key) {
            return [UIImage imageWithContentsOfFile:key];
        }];
    }
    return nil;
}

-(UIImage *)pngImg {
    if (self.pngPath) {
        return [FTCache imageForKey:_pngPath get:^UIImage *(NSString *key) {
            return [UIImage imageWithContentsOfFile:key];
        }];
    }
    if (self.gifPath) {
        return [FTCache imageForKey:_gifPath get:^UIImage *(NSString *key) {
            return [UIImage imageWithContentsOfFile:key];
        }];
    }
    return nil;
}
@end

@implementation FTBundle
{
    NSString *_name;
    BOOL _isText;
    NSString *_dir;
    NSString *_iconName;
    NSArray *_datas;
}

@synthesize isText = _isText;
@synthesize name = _name;
@synthesize icon = _icon;

static BOOL createPathIfNeed(NSString *path) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:NULL]) return YES;
    return [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
}

+(instancetype)bundleWithDir:(NSString *)dir {
    BOOL b = [[NSFileManager defaultManager] fileExistsAtPath:dir];
    if (!b) return nil;
    return [[self alloc] initWithDir:dir];
}

-(instancetype)initWithDir:(NSString *)dir {
    if (self = [super init]) {
        _dir = dir;
        [self loadData];
    }
    return self;
}

-(void)loadData {
    NSString *confPath = [_dir stringByAppendingPathComponent:@"conf.plist"];
    NSDictionary *conf = [NSDictionary dictionaryWithContentsOfFile:confPath];
    _name = conf[@"name"];
    NSAssert(_name.length > 0, @"load error: face build name unfind.");
    _iconName = conf[@"icon"];
    _isText = [conf[@"isText"] boolValue];
    NSArray *faces = conf[@"faces"];
    NSString *faceDir = [_dir stringByAppendingPathComponent:@"face"];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSDictionary *face in faces) {
        FTData *data = [FTData new];
        data.name = face[@"name"];
        data.key = face[@"key"];
        data.file = face[@"file"];
        data.dir = faceDir;
        [dataArr addObject:data];
    }
    _datas = [dataArr copy];
}

-(UIImage *)icon {
    if (!_icon) {
        NSString *icon = [_dir stringByAppendingPathComponent:_iconName];
        _icon = [UIImage imageWithContentsOfFile:icon];
    }
    return _icon;
}

@end


@implementation FTBundles
@synthesize datas = _datas;
+(instancetype)bundleWithDatas:(NSArray<FTBundle *>*)datas {
    FTBundles * bundles= [self new];
    bundles->_datas = datas;
    return bundles;
}

-(UIImage *)icon {
    return _datas.firstObject.icon;
}

-(NSString *)title {
    return _datas.firstObject.name;
}
-(BOOL)isText {
    return _datas.firstObject.isText;
}

static NSString *bundledir() {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    dir = [dir stringByAppendingPathComponent:@"FTKeyboard"];
    createPathIfNeed(dir);
    return dir;
}

+(NSArray<FTBundles *> *)loadBundles {
    NSString *dir = bundledir();
    NSString *confPath = [dir stringByAppendingPathComponent:@"conf.plist"];
    NSDictionary *conf = [NSDictionary dictionaryWithContentsOfFile:confPath];
    NSMutableArray<FTBundles *> *groups = [NSMutableArray array];
    
    NSMutableArray *agroup = [NSMutableArray array];
    for (NSString *file in conf[@"agroup"]) {
        NSString *path = [dir stringByAppendingPathComponent:file];
        FTBundle *build = [FTBundle bundleWithDir:path];
        if (build) {
            [agroup addObject:build];
        }
    }
    if (agroup.count > 0) {
        FTBundles *bundles = [FTBundles bundleWithDatas:agroup];
        [groups addObject:bundles];
    }
    
    for (NSString *file in conf[@"groups"]) {
        NSString *path = [dir stringByAppendingPathComponent:file];
        FTBundle *build = [FTBundle bundleWithDir:path];
        if (build) {
            FTBundles *bundles =[FTBundles bundleWithDatas:@[build]];
            [groups addObject:bundles];
        }
    }
    return [groups copy];
}

static void copyDirectory(NSString * from, NSString *to) {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *array = [fileManager contentsOfDirectoryAtPath:from error:nil];
    for(int i = 0; i < [array count]; i++) {
        NSString *fullPath = [from stringByAppendingPathComponent:[array objectAtIndex:i]];
        NSString *fullToPath = [to stringByAppendingPathComponent:[array objectAtIndex:i]];
        BOOL isFolder = NO;
        BOOL isExist = [fileManager fileExistsAtPath:fullPath isDirectory:&isFolder];
        if (isExist) {
            NSError *err = nil;
            [[NSFileManager defaultManager] copyItemAtPath:fullPath toPath:fullToPath error:&err];
            if (isFolder) {
                copyDirectory(fullPath, fullToPath);
            }
        }
    }
}

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *dir = bundledir();
        NSString *confPath = [dir stringByAppendingPathComponent:@"conf.plist"];
        BOOL b = [[NSFileManager defaultManager] fileExistsAtPath:confPath];
        if (b) return;
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"keyboard" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        NSString *str = [bundle pathForResource:@"conf.plist" ofType:nil];
        str = str.stringByDeletingLastPathComponent;
        copyDirectory(bundlePath, dir);
    });
}


@end

