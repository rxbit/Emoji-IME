#!/usr/bin/ruby
require 'ropencv'
include OpenCV

sample_dir = '/Users/wuhuadai/Documents/emoji_sample/Cataed'
Dir.chdir(sample_dir)
img = cv::imread('caret/9_2.png',cv::IMREAD_GRAYSCALE)
img.reshape(1,1).convert_to(img,cv::CV_32FC1)
trainClasses = cv::imread('trainClass.bmp',cv::IMREAD_GRAYSCALE)
trainClasses.convert_to(trainClasses,cv::CV_32FC1)
trainData = cv::imread('trainData.bmp',cv::IMREAD_GRAYSCALE)
trainData.convert_to(trainData,cv::CV_32FC1)
knn = CvKNearest.new(trainData,trainClasses)
puts knn.find_nearest(img,10,cv::Mat.new,cv::Mat.new,cv::Mat.new)
