//
//  TestCV.m
//  Emoji-IME
//
//  Created by Wuhua Dai on 15/2/4.
//  Copyright (c) 2015年 wua. All rights reserved.
//

#import "TestCV.h"
#import <opencv2/opencv.hpp>
#import <opencv2/highgui/ios.h>

@implementation TestCV

+(NSArray *)DetectEmojiStringsWithImage:(UIImage *)image {
    cv::Mat mat;
    UIImageToMat(image, mat);
    return nil;
}

@end
