#include "recognizer.h"

#define CPU 1
#define GPU 2


Recognizer::Recognizer() {
  width_ = 160;
  height_ = 160;
  mean_vals_[0] = 127.5f;
  mean_vals_[1] = 127.5f;
  mean_vals_[2] = 127.5f;
  norm_vals_[0] = 0.0078125f;
  norm_vals_[1] = 0.0078125f;
  norm_vals_[2] = 0.0078125f;
  float a = 1.0;
  int b = 0;
  standard_pts.push_back(cv::Point2f(55.8184375 * a - b, 45.5640625 * a - b));
  standard_pts.push_back(cv::Point2f(105.8184375 * a - b, 45.5640625 * a - b));
  standard_pts.push_back(cv::Point2f(60.54975 * a - b, 115.5566875 * a - b));
  standard_pts.push_back(cv::Point2f(99.4415625 * a - b, 115.4750625 * a - b));
}

Recognizer::~Recognizer() {
  if(net_ != nullptr) {
    net_->releaseModel();
    net_->releaseSession(session_);
  }
}

int Recognizer::Initial(std::string model_path, int device_mode) {
  net_ = MNN::Interpreter::createFromFile(model_path.c_str());
  MNN::ScheduleConfig netConfig;
  if (device_mode == CPU) {
      netConfig.type = MNN_FORWARD_CPU;
      netConfig.numThread = 2;
  }
  else if (device_mode == GPU) {
      netConfig.type = MNN_FORWARD_OPENCL;
      netConfig.numThread = 1;
  }
  else {
      printf("unsupport device mode.\n");
  }
  session_ = net_->createSession(netConfig);
  input_ = net_->getSessionInput(session_, "input.1");
  output_ = net_->getSessionOutput(session_, "1191");
 
  net_->resizeTensor(input_, {1, 3, height_, width_});
  net_->resizeSession(session_);
  
  ::memcpy(preProcessConfig_.mean, mean_vals_, sizeof(mean_vals_));
  ::memcpy(preProcessConfig_.normal, norm_vals_, sizeof(norm_vals_));
  preProcessConfig_.sourceFormat = MNN::CV::BGR;
  preProcessConfig_.destFormat = MNN::CV::RGB;
  return 0;
}

cv::Mat Recognizer::Crop(cv::Mat img, cv::Rect_<float> rect, float* points) {
    //float x1 = cv::max(rect.x, 0.f);
    //float y1 = cv::max(rect.y, 0.f);
    //float x2 = cv::min(rect.br().x, img.cols - 1.f);
    //float y2 = cv::min(rect.br().y, img.rows - 1.f);
    //cv::Mat crop = img(cv::Rect(cv::Point(x1, y1), cv::Point(x2, y2))).clone();

    //// Four corners of the book in source image
    //vector<cv::Point2f> pts_src;
    //pts_src.push_back(cv::Point2f(points[0] - x1, points[1] - y1));
    //pts_src.push_back(cv::Point2f(points[2] - x1, points[3] - y1));
    //pts_src.push_back(cv::Point2f(points[6] - x1, points[7] - y1));
    //pts_src.push_back(cv::Point2f(points[8] - x1, points[9] - y1));

    //// Calculate Homography
    //cv::Mat h = cv::findHomography(pts_src, standard_pts);

    //// Output image
    //cv::Mat im_out;
    //// Warp source image to destination based on homography
    //warpPerspective(crop, im_out, h, cv::Size(width_, height_));
    //return im_out;
    
    //std::vector<float> x{ points[0], points[2], points[4], points[6], points[8] };
    //std::vector<float> y{ points[1], points[3], points[5], points[7], points[9] };
    //std::vector<float>::iterator min_x = std::min_element(std::begin(x), std::end(x));
    //std::vector<float>::iterator max_x = std::max_element(std::begin(x), std::end(x));
    //std::vector<float>::iterator min_y = std::min_element(std::begin(y), std::end(y));
    //std::vector<float>::iterator max_y = std::max_element(std::begin(y), std::end(y));
    //float x1 = cv::max(rect.x, 0.f);
    //float y1 = cv::max(rect.y, 0.f);
    //float x2 = cv::min(rect.br().x, img.cols - 1.f);
    //float y2 = cv::min(rect.br().y, img.rows - 1.f);
    //float w = x2 - x1;
    //float h = y2 - y1;
    //float cx = (*min_x + *max_x) / 2;
    //float cy = (*min_y + *max_y) / 2;
    //float size = cv::min(w, h);
    //float x1_ = cx - size / 2;
    //float x2_ = cx + size / 2;
    //if (x1_ < x1) {
    //    x1_ = x1;
    //    x2_ = x1 + size;
    //}
    //if(x2_ > x2){
    //    x2_ = x2;
    //    x1_ = x2 - size;
    //}
    //float y1_ = cy - size / 2;
    //float y2_ = cy + size / 2;
    //if (y1_ < y1) {
    //    y1_ = y1;
    //    y2_ = y1 + size;
    //}
    //if (y2_ > y2) {
    //    y2_ = y2;
    //    y1_ = y2 - size;
    //}
    //return img(cv::Rect(cv::Point(x1_, y1_), cv::Point(x2_, y2_))).clone();

    float x1 = cv::max(rect.x, 0.f);
    float y1 = cv::max(rect.y, 0.f);
    float x2 = cv::min(rect.br().x, img.cols - 1.f);
    float y2 = cv::min(rect.br().y, img.rows - 1.f);
    return img(cv::Rect(cv::Point(x1, y1), cv::Point(x2, y2))).clone();
}

int Recognizer::Recognize(cv::Mat img, float *feat) {
    cv::Mat bgr;
    cv::resize(img, bgr, cv::Size(width_, height_));
    net_->resizeTensor(input_, { 1, 3, height_, width_});
    net_->resizeSession(session_);

    MNN::CV::ImageProcess* pretreat_ = MNN::CV::ImageProcess::create(preProcessConfig_);
    pretreat_->convert(bgr.data, width_, height_, bgr.step[0], input_);
    net_->runSession(session_);

    MNN::Tensor outHost(output_, MNN::Tensor::CAFFE);

    output_->copyToHostTensor(&outHost);

    std::vector<int> shape0 = outHost.shape();

    int c = shape0[0];
    int length = shape0[1];
    auto out_data = outHost.host<float>();
    //float nor_val = 0.;
    //for (int i = 0; i < length; i++) {
    //    nor_val += (out_data[i] * out_data[i]);
    //}
    //nor_val = sqrt(nor_val);
    for (int i = 0; i < length; i++) {
        feat[i] = out_data[i];
    }

    return 0;
}

float Recognizer::simd_dot(const float* x, const float* y, const long& len) {
    float inner_prod = 0.0f;
    for (long i = 0; i < len; ++i) {
        inner_prod += x[i] * y[i];
    }
    return inner_prod;
}

float Recognizer::CalcDistance(float* fc1, float* fc2, long dim) {
    float nor_val1 = 0., nor_val2 = 0.;
    for (int i = 0; i < dim; i++) {
        nor_val1 += (fc1[i] * fc1[i]);
        nor_val2 += (fc2[i] * fc2[i]);
    }
    nor_val1 = sqrt(nor_val1);
    nor_val2 = sqrt(nor_val2);
    for (int i = 0; i < dim; i++) {
        fc1[i] = fc1[i] / nor_val1;
        fc2[i] = fc2[i] / nor_val2;
    }

    float dis = 0.;
    for (int fidx = 0; fidx < dim; fidx++) {
        dis = dis + (fc1[fidx] - fc2[fidx]) * (fc1[fidx] - fc2[fidx]);
    }
    if (dis == 0) {
        return 0;
    }
    else {
        return sqrt(dis);
    }
}

float Recognizer::CalcSimilarity(float *fc1, float *fc2, long dim) {
    return simd_dot(fc1, fc2, dim) / (sqrt(simd_dot(fc1, fc1, dim)) * sqrt(simd_dot(fc2, fc2, dim)));
}
