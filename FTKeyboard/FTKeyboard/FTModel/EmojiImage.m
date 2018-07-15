//
//  EmojiImage.m
//  FTKeyboard
//
//  Created by YLCHUN on 2018/7/11.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import "EmojiImage.h"
#import <UIKit/UIKit.h>

static UIImage *_clipImage(UIImage *image, CGRect rect) {
    rect.size.width *= image.scale;
    rect.size.height *= image.scale;
    CGImageRef imgRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    image = [UIImage imageWithCGImage:imgRef scale:image.scale orientation:image.imageOrientation];
    return image;
}

static UIImage *_textImage(NSString *text, CGFloat fontSize) {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *attributes = @{NSFontAttributeName : font};
    CGSize size = [text sizeWithAttributes:attributes];
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    [text drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

static CGRect _imageContentRect(UIImage *image)
{
    const int width = image.size.width;
    const int height = image.size.height;
    size_t bytesPerRow = width * 4;
    uint32_t* buffer = (uint32_t*)malloc(bytesPerRow * height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(buffer, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    
    int pixelNum = width * height;
    int minX = width, minY = height, maxX = 0, maxY = 0;
    for (int i = 0; i < pixelNum; i++) {
        uint8_t *ptr = (uint8_t *)(buffer + i);
        if (ptr[3] > 0 || ptr[2] > 0 || ptr[1] > 0) {
            int x = i % width;
            int y = i / width;
            if(x < minX) minX = x;
            if(y < minY) minY = y;
            if(x > maxX) maxX = x;
            if(y > maxY) maxY = y;
        }
    }
    free(buffer);
    CGContextRelease(context);
    CGRect frame = CGRectMake(minX, minY, maxX - minX, maxY - minY + image.scale);
    return frame;
}

UIImage *emojiImage(NSString *text, CGFloat fontSize) {
    UIImage *img = _textImage(text, fontSize);
    CGRect rect = _imageContentRect(img);
//    rect.size.height = img.size.height;
    img = _clipImage(img, rect);
    return img;
}
