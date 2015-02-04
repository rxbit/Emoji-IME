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

using namespace std;

@implementation TestCV {
}
NSArray *table;
cv::KNearest knn;

+(NSArray *)DetectEmojiStringsWithImage:(UIImage *)image {
    NSMutableArray *emojiStrings = [[NSMutableArray alloc]init];
    cv::Mat mat;
    UIImageToMat(image, mat);
    cv::Mat small;
    int fixedHeight = 64;
    cv::Size size(fixedHeight*mat.cols/mat.rows, fixedHeight);
    cv::resize(mat, small, size);
    cv::Mat gray;
    cv::cvtColor(small, gray, CV_BGR2GRAY);
    int threshold = 60;
    cv::Mat bin;
    cv::threshold(gray, bin, threshold, 255, CV_THRESH_BINARY);
    vector<vector<cv::Point>> contours;
    vector<cv::Vec4i> hierarchy;
    vector<cv::Rect> rectArray;
    vector<int> resultArray;
    
    cv::findContours(bin, contours, hierarchy, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);
    
    for (auto i: contours) {
        if (cv::contourArea(i) > 50) {
            auto rect = cv::boundingRect(i);
            if (rect.height > 20) {
                rectArray.push_back(rect);
            }
        }
    }
    
    sort(rectArray.begin(),rectArray.end(),[](cv::Rect a, cv::Rect b) {
        return a.x > b.x;
    });
    
    for (auto i: rectArray) {
        auto sample = bin(i);
        sample.reshape(1).convertTo(sample, CV_32FC1);
//        auto result = (int)knn.find_nearest(sample, 1);
//        resultArray.push_back(result);
    }
    
    for (auto i:resultArray) {
        [emojiStrings addObject:table[i]];
    }
    
    
    return emojiStrings;
}

@end
