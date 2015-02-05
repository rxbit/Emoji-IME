#!/usr/bin/ruby
require 'ropencv'
include OpenCV
$ClassIndex = 0
$ClassHash = Hash.new
$ClassMat = Array.new
$trainData = Array.new
$dictString = ""

def parserimage(file)
	image = nil
	puts "打开文件 #{file}"
	image = cv::imread(file,cv::IMREAD_GRAYSCALE)
	image.reshape(1,1).convert_to(image,cv::CV_32FC1)
	#puts image.size
	$trainData.push(image)
	$ClassMat.push($ClassIndex)
end

def getCharacter(path)
	f = File.open(path+"/unicode","r")
	return f.readline.strip
end

sample_dir = '/Users/wuhuadai/Documents/emoji_sample/Cataed'
Dir.chdir(sample_dir)
Dir.foreach('.') do |x|
	if File.directory?(x)
		Dir.foreach(x) do |y|
			if File.basename(y) =~/.*\.png$/
				parserimage(x+"/"+y)
				if not $ClassHash.has_key?(x)
					$ClassHash[x]=$ClassIndex
					$dictString += "@\"#{getCharacter(x)}\","
					$ClassIndex+=1
				end
			end
		end
	end
end
#puts $ClassHash
#puts $ClassMat

traindata = cv::Mat.new($trainData.size,256,cv::CV_32FC1)
trainClass = cv::Mat.new($trainData.size,1,cv::CV_32FC1)
$trainData.each_with_index do |v,i|
	cv::imshow('',v)
	v.copy_to(traindata.row(i))
	trainClass[i,0] = $ClassMat[i]
end
cv::imshow('',traindata)
cv::wait_key()
cv::imshow('',trainClass)
cv::wait_key()
cv::imwrite('trainData.bmp',traindata)
cv::imwrite('trainClass.bmp',trainClass)
puts $dictString
puts '结束'
