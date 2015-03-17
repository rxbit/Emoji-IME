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

@interface TestCV ()
@property (nonatomic,assign) cv::KNearest *knn;
@end

@implementation TestCV {
}


+(TestCV*)sharedInstance {
    static TestCV* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

NSArray *table = @[@"\u0434",@"3",@"ω",@"\u3064",@"ﾉ",@"ɛ",@"X",@"∩",@"(",@")",@"∀",@"*",@"\u005e",@"\u00b0",@"・",@"←",@"→",];

-(cv::KNearest*)knn {
    if(!_knn) {
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
        _knn = new cv::KNearest(trainData, trainClass);
    }
    return _knn;
}

-(NSArray *)DetectEmojiStringsWithImage:(UIImage *)image {
    NSMutableArray *emojiStrings = [[NSMutableArray alloc]init];
    NSMutableArray *tempStrings = [[NSMutableArray alloc]init];
    cv::Mat mat;
    //UIImage转换为OpenCV图像
    UIImageToMat(image, mat);
    //转成灰度图像
    cv::cvtColor(mat, mat, CV_BGR2GRAY);
    //反色并二值化
    int threshold = 60;
    cv::threshold(mat, mat, threshold, 255, CV_THRESH_BINARY_INV|CV_THRESH_OTSU);
    //去除边界
    
    cv::Rect rect = cv::Rect(-1,-1,-1,-1);
    
    for (int c = 0; c < mat.cols && rect.x == -1; ++c) {
        for (int r = 0; r < mat.rows; ++r) {
            if (mat.at<uchar>(r,c) == 255) {
                rect.x = c;
                break;
            }
        }
    }
    
    for (int r = 0; r < mat.rows && rect.y == -1; ++r) {
        for (int c = 0; c < mat.cols; ++c) {
            if (mat.at<uchar>(r,c) == 255) {
                rect.y = r;
                break;
            }
        }
    }
    
    for (int c = mat.cols-1; c >= 0 && rect.width == -1; --c) {
        for (int r = 0; r < mat.rows; ++r) {
            if (mat.at<uchar>(r,c) == 255) {
                rect.width = c-rect.x;
                break;
            }
        }
    }
    
    for (int r = mat.rows-1; r >= 0 && rect.height == -1; --r) {
        for (int c = 0; c < mat.cols; ++c) {
            if (mat.at<uchar>(r,c) == 255) {
                rect.height = r-rect.y;
                break;
            }
        }
    }
    
    mat(rect).copyTo(mat);
    
    int fixedHeight = 48;
    auto size = cv::Size(fixedHeight*mat.cols/mat.rows,fixedHeight);
    cv::resize(mat, mat, size);
    cv::threshold(mat, mat, threshold, 255, CV_THRESH_BINARY|CV_THRESH_OTSU);
    
    vector<vector<cv::Point>> contours;
    vector<cv::Vec4i> hierarchy;
    vector<cv::Rect> rectArray;
    vector<int> resultArray;
    
    auto bin2 = mat.clone();
    cv::findContours(bin2, contours, hierarchy, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);
    
    for (auto i: contours) {
        auto rect = cv::boundingRect(i);
        if (rect.area() > 16) {
                rectArray.push_back(rect);
        }
    }
    
    sort(rectArray.begin(),rectArray.end(),[](cv::Rect a, cv::Rect b) {
        return a.x < b.x;
    });
    
    for (auto i: rectArray) {
        cv::Mat sample;
        mat(i).copyTo(sample);
        auto h = sample.rows < 24?8:16;
        auto w = sample.cols < 24?8:16;
        cv::resize(sample, sample, cv::Size(w,h));
        cv::Mat bg = cv::Mat().zeros(16, 16, sample.type());
        auto r = ((float)w)/(float)h;
        auto x = r < 1 ? 8 : 0;
        auto y = r > 1 ? 8 : 0;
        auto subrect = cv::Rect(x,y,w,h);
        sample.copyTo(bg(subrect));
        cv::threshold(bg, bg, 10, 255, CV_THRESH_OTSU|CV_THRESH_BINARY);
        bg.reshape(1,1).convertTo(bg, CV_32FC1);
        auto result = (int)(self.knn->find_nearest(bg, 1));
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
    }
    
    return emojiStrings;
}

- (void)dealloc
{
    delete _knn;
}

@end
