//
//  AppDelegate.m
//  FTKeyboard
//
//  Created by YLCHUN on 2018/7/9.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import "AppDelegate.h"
#import "EmojiImage.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

static BOOL createPathIfNeed(NSString *path) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:NULL]) return YES;
    return [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
}
- (void )emoji {
    NSString* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"emoji"];
    createPathIfNeed(path);
    NSString *facePath = [path stringByAppendingPathComponent:@"face"];
    createPathIfNeed(facePath);
    
    #define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);
    NSMutableDictionary *emojiConf = [NSMutableDictionary dictionary];
    emojiConf[@"name"] = @"emoji";
    emojiConf[@"isText"] = @(YES);
    emojiConf[@"icon"] = @"emoji@2x";
    
    NSMutableArray *faces = [NSMutableArray new];
    for (int i=0x1F600; i<=0x1F64F; i++) {
        if (i < 0x1F641 || i > 0x1F644) {
            int sym = EMOJI_CODE_TO_SYMBOL(i);
            NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
            NSString *key = [NSString stringWithFormat:@"%d", i];
            NSString *file = [NSString stringWithFormat:@"emoji%@", key];
//            NSString *gifName = [file stringByAppendingString:@"@2x.gif"];
            NSString *pngName = [file stringByAppendingString:@"fix@2x.png"];
            NSString *filePath = [facePath stringByAppendingPathComponent:pngName];
            UIImage *image = emojiImage(emoT, 60);
            [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
            NSDictionary *dict = @{@"file":file,
                                   @"key":[NSString stringWithFormat:@"[%@]", key],
                                   @"name":emoT
                                   };
            [faces addObject:dict];
        }
    }
    emojiConf[@"faces"] = faces;
    
    NSString *confPath = [path stringByAppendingPathComponent:@"conf.plist"];
    [emojiConf writeToFile:confPath atomically:YES];
    [faces writeToFile:path atomically:YES];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [self emoji];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
