/*
 * Filename: /Users/bakbeom/work/bioCube/face_kit/ios/Classes/native_opencv copy.cpp
 * Path: /Users/bakbeom/work/bioCube/face_kit/ios/Classes
 * Created Date: Saturday, March 11th 2023, 4:37:11 pm
 * Author: bakbeom
 * 
 * Copyright (c) 2023 BioCube
 */



#include <opencv2/opencv.hpp>
#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/objdetect.hpp>
#include <MNN/ImageProcess.hpp>
#include "FaceCubePlus.h"
#include <chrono>
#include <iostream>
#include <stdio.h>
#if defined(WIN32) || defined(_WIN32) || defined(__WIN32)
#define IS_WIN32
#endif

#ifdef __ANDROID__
#include <android/log.h>
#endif

#ifdef IS_WIN32
#include <windows.h>
#endif

#if defined(__GNUC__)
    // Attributes to prevent 'unused' function from being removed and to make it visible
    #define FUNCTION_ATTRIBUTE __attribute__((visibility("default"))) __attribute__((used))
#elif defined(_MSC_VER)
    // Marking a function for export
    #define FUNCTION_ATTRIBUTE __declspec(dllexport)
#endif

using namespace std;
using namespace cv;
using namespace fcp;
// if andoid mask this line.
static cv::CascadeClassifier opencvfaceDetector;
static fcp::FaceIdentification* mnnfaceIdentification ;
static fcp::FaceDetection* mnnfaceDetector ;
static char* testOutputPath;
long long int get_now() {
    return chrono::duration_cast<std::chrono::milliseconds>(
            chrono::system_clock::now().time_since_epoch()
    ).count();
}

void rotateMat(Mat &matImage, int rotation)
{
	if (rotation == 90) {
		transpose(matImage, matImage);
		flip(matImage, matImage, 1); //transpose+flip(1)=CW
	} else if (rotation == 270) {
		transpose(matImage, matImage);
		flip(matImage, matImage, 0); //transpose+flip(0)=CCW
	} else if (rotation == 180) {
		flip(matImage, matImage, -1);    //flip(-1)=180
	}
}

void platform_log(const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
#ifdef __ANDROID__
    __android_log_vprint(ANDROID_LOG_VERBOSE, "ndk", fmt, args);
#elif defined(IS_WIN32)
    char *buf = new char[4096];
    std::fill_n(buf, 4096, '\0');
    _vsprintf_p(buf, 4096, fmt, args);
    OutputDebugStringA(buf);
    delete[] buf;
#else
    vprintf(fmt, args);
#endif
    va_end(args);
}

static const std::string base64_chars =
"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
"abcdefghijklmnopqrstuvwxyz"
"0123456789+/";
	static inline bool is_base64(unsigned char c) {
		return (isalnum(c) || (c == '+') || (c == '/'));
	}

	std::string base64_decode(std::string const& encoded_string) {
		int in_len = encoded_string.size();
		int i = 0;
		int j = 0;
		int in_ = 0;
		unsigned char char_array_4[4], char_array_3[3];
		std::string ret;

		while (in_len-- && (encoded_string[in_] != '=') && is_base64(encoded_string[in_])) {
			char_array_4[i++] = encoded_string[in_]; in_++;
			if (i == 4) {
				for (i = 0; i < 4; i++)
					char_array_4[i] = base64_chars.find(char_array_4[i]);

				char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
				char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
				char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

				for (i = 0; (i < 3); i++)
					ret += char_array_3[i];
				i = 0;
			}
		}

		if (i) {
			for (j = i; j < 4; j++)
				char_array_4[j] = 0;

			for (j = 0; j < 4; j++)
				char_array_4[j] = base64_chars.find(char_array_4[j]);

			char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
			char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
			char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

			for (j = 0; (j < i - 1); j++) ret += char_array_3[j];
		}

		return ret;
	}
	std::vector<float> split(std::string str,std::string pattern)
	{
		std::string::size_type pos;
		std::vector<float> result;
		str+=pattern;//扩展字符串以方便操作
		int size=str.size();
	
		for(int i=0; i<size; i++)
		{
			pos=str.find(pattern,i);
			if(pos<size)
			{
				std::string s=str.substr(i,pos-i);
				result.push_back(std::stof(s));
				i=pos+pattern.size()-1;
			}
		}
		return result;
	}
// Avoiding name mangling
extern "C" {
    FUNCTION_ATTRIBUTE
    const char* version() {
        return CV_VERSION;
    }


	
    FUNCTION_ATTRIBUTE
    void process_image(char* inputImagePath, char* outputImagePath,int width, int height, int rotation, uint8_t* bytes, bool isYUV) {
		Mat frame;
		if (isYUV) {
			// android
			Mat yuv(height + height/2, width, CV_8UC1, bytes);
			cvtColor(yuv , frame, COLOR_YUV2BGRA_NV21);
		} else {
			// ios
			frame = Mat(height, width, CV_8UC4, bytes);
		}
		cv::Mat gray;
		std::vector<cv::Rect>faces;
		cv::rotate(frame,frame,cv::ROTATE_90_COUNTERCLOCKWISE);
		// cvtColor(frame, gray, COLOR_BGRA2GRAY);
		// equalizeHist(gray, gray);
    	opencvfaceDetector.detectMultiScale( gray, faces,1.1,5);
		vector<float> output;
		cv::imwrite(outputImagePath,frame);
		platform_log("Wirte Image Done :: %d\n", outputImagePath);
		
    }

    // Attributes to prevent 'unused' function from being removed and to make it visible
	FUNCTION_ATTRIBUTE
	void initDetector(uint8_t* markerPngBytes, int inBytesCount, int bits,char* outputTestPath) {
		testOutputPath = outputTestPath;
		// detector model.
		// vector<uint8_t> buffer(markerPngBytes, markerPngBytes + inBytesCount);
		// Mat marker = imdecode(buffer, IMREAD_COLOR);
		// int rows = marker.rows;
		// int cols = marker.cols;
		// cv::Size s = marker.size();
		// rows = s.height;
		// cols = s.width;
		// mnnfaceDetector = new fcp::FaceDetection(opencvModlePath,rows,cols,1,70);
	}
	FUNCTION_ATTRIBUTE
	void initMnnModel(char* mnnModelPath,char* opencvPath) {
		if (mnnfaceIdentification != nullptr) {
			delete mnnfaceIdentification;
			mnnfaceIdentification = nullptr;
		}
		mnnfaceIdentification = new fcp::FaceIdentification(mnnModelPath,1);
		assert(opencvfaceDetector.load(opencvPath));
		
		
	}

	FUNCTION_ATTRIBUTE
	void destroyDetector() {
		if (mnnfaceIdentification != nullptr) {
			delete mnnfaceIdentification;
			mnnfaceIdentification = nullptr;
			
		}
		if (mnnfaceDetector != nullptr) {
			delete mnnfaceIdentification;
			mnnfaceIdentification = nullptr;
			
		}
		free( testOutputPath);
		
	}
	

	

	FUNCTION_ATTRIBUTE
	const float* matchFaeture(char* feat1, char*  feat2) {
		
		float *f1 =(float*)malloc(512);
		float *f2 =(float*)malloc(512);
		vector<float>  f1StrList = split(feat1,",");
		vector<float>  f2StrList = split(feat2,",");
		memcpy(f1, f1StrList.data(), 512);
		memcpy(f2, f1StrList.data(), 512);
		float res = mnnfaceIdentification->CalcSimilarity(f1,f2);
		int  total =sizeof(float) * 1;
		float *result = (float*)malloc(total);
		result  = &res;
		free(f1);
		free(f2);
		return result;			
	}
	FUNCTION_ATTRIBUTE
	const float* extractFaeture( char* base64Data, float* feat,int32_t* isSuccessful) {
		platform_log("is In ");
		string decoded_string = base64_decode(base64Data);
		vector<uchar> data(decoded_string.begin(), decoded_string.end());
		Mat img = imdecode(data, IMREAD_UNCHANGED);


		cv::Mat gray;
		std::vector<cv::Rect>faces;
		cvtColor(img, gray, COLOR_BGRA2GRAY);
		equalizeHist(gray, gray);
		opencvfaceDetector.detectMultiScale( gray, faces,1.1,5);
		vector<float> output;
		output.push_back(1.0);
		// if (faces.size()==1 && faces[0].width>80){
		// 	output.push_back(faces[0].x);
		// 	output.push_back(faces[0].y);
		// 	output.push_back(faces[0].width);
		// 	platform_log("Face X :: %d\n", faces[0].x);
		// 	platform_log("Face Y :: %d\n", faces[0].y);
		// 	platform_log("Face Width :: %d\n", faces[0].width);
		// 	platform_log("Face Height :: %d\n", faces[0].height);
		// 	if (mnnfaceIdentification!= nullptr)
		// 	{
		// 	cv::Rect2f td;
		// 	cv::Mat crop;
		// 	td.x = faces[0].x;
		// 	td.y = faces[0].y;
		// 	td.width = faces[0].width;
		// 	td.height = faces[0].height;
		// 		float *points = (float*)malloc(sizeof(float) * output.size());
		// 		crop =  mnnfaceIdentification->CropFace(gray,td,points);
		// 		if (crop.cols!=0)
		// 		{
		// 			*isSuccessful =  mnnfaceIdentification->ExtractFeature(crop,feat);
					
		// 			platform_log("Wirte Image Done :: %d\n", testOutputPath);
		// 			platform_log("Points :: %d\n", points);
		// 			platform_log("Feat :: %d\n", feat);
		// 		}

		// 		free(points);
				
		// 	}
		// }else{
		// 	faces.clear();
		// 	output.clear();
		// 	feat = nullptr;
		// 	*isSuccessful = 0;
		// }
		unsigned int total = sizeof(float) * output.size();
		float* jres = (float*)malloc(total);
		memcpy(jres, output.data(), total);
	// float* jres = (float*)malloc(1);
	return jres;			
	}


	FUNCTION_ATTRIBUTE
	const float* detectFrame(int width, int height, int rotation, uint8_t* bytes, bool isYUV, int32_t* outCount,  float* feat) {
		Mat frame;
		if (isYUV) {
			// android
			Mat yuv(height + height/2, width, CV_8UC1, bytes);
			cvtColor(yuv , frame, COLOR_YUV2BGRA_NV21);
			cv::rotate(frame,frame,cv::ROTATE_90_COUNTERCLOCKWISE);
		} else {
			// ios
			frame = Mat(height, width, CV_8UC4, bytes);
		}
		cv::Mat gray;
		std::vector<cv::Rect>faces;
		cvtColor(frame, gray, COLOR_BGRA2GRAY);
		equalizeHist(gray, gray);
    	opencvfaceDetector.detectMultiScale( gray, faces,1.1,5);
		vector<float> output;
		if (faces.size()==1 && faces[0].width>100){
			output.push_back(faces[0].x);
			output.push_back(faces[0].y);
			output.push_back(faces[0].width);

			platform_log("Face X :: %d\n", faces[0].x);
			platform_log("Face Y :: %d\n", faces[0].y);
			platform_log("Face Width :: %d\n", faces[0].width);
			platform_log("Face Height :: %d\n", faces[0].height);
			
			if (mnnfaceIdentification!= nullptr)
			{
			cv::Rect2f td;
			cv::Mat crop;
			td.x = faces[0].x;
			td.y = faces[0].y;
			td.width = faces[0].width;
			td.height = faces[0].height;
		    float *points = (float*)malloc(sizeof(float) * output.size());
			crop =  mnnfaceIdentification->CropFace(gray,td,points);
			
				if (crop.cols!=0)
				{
					mnnfaceIdentification->ExtractFeature(crop,feat);
					platform_log("Wirte Image Done :: %d\n", testOutputPath);
					platform_log("Points :: %d\n", points);
					platform_log("Feat :: %d\n", feat);
				}

			free(points);
			}
		}else{
			faces.clear();
			output.clear();
			feat = nullptr;
		}
		unsigned int total = sizeof(float) * output.size();
		float* jres = (float*)malloc(total);
		memcpy(jres, output.data(), total);
		*outCount = output.size();
		return jres;
		
	}
}

