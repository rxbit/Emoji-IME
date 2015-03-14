//
//  TestCV.h
//  Emoji-IME
//
//  Created by Wuhua Dai on 15/2/4.
//  Copyright (c) 2015年 wua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TestCV : NSObject

+(TestCV*)sharedInstance;
-(NSArray *)DetectEmojiStringsWithImage:(UIImage *)image;
-(void) TrainKnn;

@end
