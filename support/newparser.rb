#!/usr/bin/ruby
require 'digest'
require 'ropencv'
include OpenCV


def showImage(img)
	cv::imshow('',img)
#	cv::wait_key()
end

def parserImage(file)
	img = nil
	begin
		puts "打开文件 #{file}"
		img= cv::imread(file, CV_LOAD_IMAGE_COLOR)
	rescue
		puts '打开图片时出错。'
		exit
	end
	showImage(img)

	cv::cvtColor(img,img,CV_BGR2GRAY)
	puts "灰度化"
	showImage(img)

	threshold = 60
	cv::threshold(img,img,threshold,255,CV_THRESH_BINARY_INV|CV_THRESH_OTSU)
	puts "反色二值化"
	showImage(img)

  puts img.type

  puts "规格化"
  left = -1
  img.each_col_with_index do |c,ci|
    c.each_with_index do |e,ei| left = ci and break if e == 255 end
    break if left != -1
  end
  puts left

  top = -1
  img.each_row_with_index do |r,ri|
    r.each_with_index do |e,ei| top = ri and break if e == 255 end
    break if top != -1
  end
  puts top

  img_f = img.clone
  cv::flip(img_f,img_f,-1)

  right = -1
  img_f.each_col_with_index do |c,ci|
    c.each_with_index do |e,ei| right = ci and break if e == 255 end
    break if right != -1
  end
  right = img_f.cols - right
  puts right

  bottom = -1
  img_f.each_row_with_index do |r,ri|
    r.each_with_index do |e,ei| bottom = ri and break if e == 255 end
    break if bottom != -1
  end
  bottom = img_f.rows - bottom
  puts bottom

  rect = cv::Rect.new(left,top,right-left+1,bottom-top+1)

  img.block(rect).copy_to(img)
	fixedHeight = 48
	size = cv::Size.new(fixedHeight*img.cols/img.rows, fixedHeight)
	cv::resize(img,img,size)
	puts "缩放至指定高度 #{fixedHeight}"
	showImage(img)
	threshold = 60
	cv::threshold(img,img,threshold,255,CV_THRESH_BINARY|CV_THRESH_OTSU)
	puts "再次二值化"
	showImage(img)
	contours = std::Vector::Cv_Mat.new()
	hierarchy = cv::Mat.new()
	bin = img.clone()
	cv::find_contours(bin, contours, hierarchy, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE)

	contours.each do |c| rect = cv::bounding_rect(c)
		puts "子图像面积 #{rect.area()}"
		sample = cv::Mat.new()
		img.block(rect).copy_to(sample)
		showImage(sample)
    h = sample.rows < 24?8:16
    w = sample.cols < 24?8:16
    size = cv::Size.new(w,h)
    cv::resize(sample,sample,size)
    showImage(sample)
    bg = cv::Mat.zeros(16,16,sample.type)
    showImage(bg)
    r = Float(w)/Float(h)
    x = r < 1?8:0
    y = r > 1?8:0
    rect = cv::Rect.new(x,y,w,h)
    sample.copy_to(bg.block(rect))
    showImage(bg)
    digest = Digest::SHA1.hexdigest bg.to_s
    puts digest
    cv::imwrite('UnCata/'+digest+'.png',bg)
	end
end


sample_dir = '/Users/wuhuadai/Documents/emoji_sample/'
Dir.chdir(sample_dir)
Dir.mkdir('UnCata') if not Dir.exist?('UnCata')
Dir.foreach(sample_dir) do |file| 
	parserImage(file) if File.basename(file) =~/.*\.png$/
end
puts '处理完成'

