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
NSArray *table = @[@"<",@">",@"\u0434",@"ω",@"\u3064",@"\u0054",@"u",@"(",@")",@"\u005e",@"\u00b0",@"→",@"_",];
cv::KNearest *knn;

void TrainKnn() {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *trainDataPath = [bundle pathForResource:@"trainData" ofType:@"bmp"];
    NSString *trainClassPath = [bundle pathForResource:@"trainClass" ofType:@"bmp"];
    cv::Mat trainData, trainClass;
    trainData = cv::imread([trainDataPath fileSystemRepresentation],cv::IMREAD_GRAYSCALE);
    trainClass = cv::imread([trainClassPath fileSystemRepresentation],cv::IMREAD_GRAYSCALE);
    if (!trainData.data || !trainClass.data) {
        NSLog(@"读取训练数据源出错。");
    }
    trainData.convertTo(trainData, CV_32FC1);
    trainClass.convertTo(trainClass, CV_32FC1);
    knn = new cv::KNearest(trainData, trainClass);
}

+(NSArray *)DetectEmojiStringsWithImage:(UIImage *)image {
    if (!knn) TrainKnn();
    NSMutableArray *emojiStrings = [[NSMutableArray alloc]init];
    NSMutableArray *tempStrings = [[NSMutableArray alloc]init];
    cv::Mat mat;
    UIImageToMat(image, mat);
    cv::Mat small;
    int fixedHeight = 80;
    cv::Size size(fixedHeight*mat.cols/mat.rows, fixedHeight);
    cv::resize(mat, small, size);
    cv::Mat gray;
    cv::cvtColor(small, gray, CV_BGR2GRAY);
    int threshold = 60;
    cv::Mat bin;
    cv::threshold(gray, bin, threshold, 255, CV_THRESH_BINARY_INV|CV_THRESH_OTSU);
    vector<vector<cv::Point>> contours;
    vector<cv::Vec4i> hierarchy;
    vector<cv::Rect> rectArray;
    vector<int> resultArray;
    
    auto bin2 = bin.clone();
    cv::findContours(bin2, contours, hierarchy, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);
    
    for (auto i: contours) {
        auto rect = cv::boundingRect(i);
        if (rect.area() > 64) {
                rectArray.push_back(rect);
        }
    }
    
    sort(rectArray.begin(),rectArray.end(),[](cv::Rect a, cv::Rect b) {
        return a.x < b.x;
    });
    
    for (auto i: rectArray) {
        cv::Mat sample;
        bin(i).copyTo(sample);
        cv::resize(sample, sample, cv::Size(16,16));
        cv::threshold(sample, sample, 10, 255, CV_THRESH_OTSU|CV_THRESH_BINARY);
        sample.reshape(1,1).convertTo(sample, CV_32FC1);
        auto resultf = knn->find_nearest(sample, 3);
        auto result = (int)resultf;
        NSLog(@"识别结果%@", table[result]);
        resultArray.push_back(result);
    }
    
    for (auto i:resultArray) {
        if (i >= 0 && i <= [table count]) {
            [tempStrings addObject:table[i]];
        }
    }
    
    if ([tempStrings count] != 0) {
        [emojiStrings addObject: [tempStrings componentsJoinedByString:@""]];
        [emojiStrings addObject: [tempStrings componentsJoinedByString:@""]];
        [emojiStrings addObject: [tempStrings componentsJoinedByString:@""]];
    }
    
    return emojiStrings;
}

- (void)dealloc
{
    delete knn;
}

@end
