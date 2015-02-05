#!/usr/bin/ruby
require 'ropencv'
include OpenCV

def vertTouYing(image)
	subImageArr = Array.new
	contours = Std::Vector::Cv_Mat.new
	hierarchy = Cv::Mat.new
	imagec = image.clone
	cv::find_contours(image,contours,hierarchy,CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE)
	contours.each do |i|
		rect = cv::bounding_rect(i)
		puts rect
		x = imagec.block(rect)
		cv::resize(x,x,cv::Size.new(16,16))
		showImage(x)
		subImageArr.push(x)

	end
	return subImageArr
end

def showImage(image)
	cv::imshow('',image)
	cv::wait_key()
end


def parserImage(file)
	image = nil
	begin
		puts "打开文件 #{file}"
		image = cv::imread(file)
	rescue
		puts '打开图片时出错。'
		exit
	end
	showImage(image)

	fixedHeight = 64
	size = cv::Size.new(image.cols*fixedHeight/image.rows ,fixedHeight)
	puts "缩放至指定高度 #{fixedHeight}"
	cv::resize(image,image,size)
	showImage(image)

	puts '转换成灰度图像'
	cv::cvt_color(image,image,CV_BGR2GRAY)
	showImage(image)

	puts '图像二值化'
	threshold = 60
	cv::threshold(image,image,threshold,255,CV_THRESH_BINARY|CV_THRESH_OTSU)
	showImage(image)

	puts '进行垂直投影'
	puts '保存分割后图像'
	param =Array.new
	vertTouYing(image).each_with_index do |v,i|
		threshold = 60
		cv::threshold(v,v,threshold,255,CV_THRESH_BINARY|CV_THRESH_OTSU)
		cv::imwrite("UnCata/"+File.basename(file,'.png')+"_#{i}.png",v)
	end
	puts '-----------------------------'
end

puts '启动中。。。'

sample_dir = '/Users/wuhuadai/Documents/emoji_sample/'
Dir.chdir(sample_dir)
Dir.mkdir('UnCata') if not Dir.exist?('UnCata')
Dir.foreach(sample_dir) do |file|
	parserImage(file) if File.basename(file) =~/.*\.png$/
end
puts '处理完成'
