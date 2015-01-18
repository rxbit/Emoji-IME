require 'opencv'
include OpenCV

$window = GUI::Window.new('图片结果')

def horTouYing(image)
	array = Array.new(image.height)
	for i in 0...image.height
		whitePoint = 0
		for j in 0...image.width
			whitePoint += 1 if image[i,j][0] == 255.0
		end
		array[i] = whitePoint
	end
	puts array
	start = nil
	stop = nil
	for i in 0...array.size
		if !start and array[i] > 1
			start = i
			break
		end
	end
	for i in 0...array.size
		if !stop and array[array.size-i-1] > 1
			stop = array.size-i-1
			break
		end
	end
	showImage(image.sub_rect(CvRect.new(0,start,image.width,stop-start+1)))
end

def vertTouYing(image)
	array = Array.new(image.width)
	for i in 0...image.width
		whitePoint = 0
		for j in 0...image.height
			whitePoint += 1 if image[j,i][0] == 255.0
		end
		array[i] = whitePoint
	end
	puts array
	start = nil
	rectArr = Array.new
	for i in 0...array.size
		if !start and array[i] > 1
			start = i
		elsif start and array[i] < 2
			width = i - start
			rectArr.push(CvRect.new(start,0,width,image.height))
			start = nil
		end
	end
	puts rectArr
	rectArr.each do |rect|
		subimg = image.sub_rect(rect)
		showImage(subimg)
		horTouYing(subimg)
	end
end

def showImage(image)
	$window.show(image)
	GUI::wait_key
end


def parserImage(file)
	image = nil
	begin
		puts "打开文件 #{file}"
		image= CvMat.load(file, CV_LOAD_IMAGE_COLOR)
	rescue
		puts '打开图片时出错。'
		exit
	end
	showImage(image)

	fixedHeight = 64
	size = CvSize.new(image.width*fixedHeight/image.height ,fixedHeight)
	puts "缩放至指定高度 #{fixedHeight}"
	image = image.resize(size)
	showImage(image)

	puts '转换成灰度图像'
	image = image.BGR2GRAY
	showImage(image)

	puts '图像二值化'
	threshold = 60
	image,_ = image.threshold(threshold, 255, CV_THRESH_BINARY,true)
	showImage(image)

	puts '进行垂直投影'
	vertTouYing(image)
	puts '-----------------------------'
	exit
end

puts '启动中。。。'

sample_dir = '/Users/wuhuadai/Documents/emoji_sample/'
Dir.chdir(sample_dir)
Dir.foreach(sample_dir) do |file| 
	parserImage(file) if File.basename(file) =~/.*\.png$/
end
