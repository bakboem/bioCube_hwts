#pragma

#include <MNN/ImageProcess.hpp>
#include <MNN/Interpreter.hpp>
#include <opencv2/opencv.hpp>
#include <opencv2/highgui.hpp>

struct Person {
    std::string name;
    float feat[512];
};

class Recognizer {
public:
    Recognizer();
    int Initial(std::string model_path, int device_mode);
    ~Recognizer();
    int Recognize(cv::Mat img, float* feat);
    cv::Mat Crop(cv::Mat img, cv::Rect_<float> rect, float* points);
    float CalcDistance(float* fc1, float* fc2, long dim);
    float CalcSimilarity(float* fc1, float* fc2, long dim);
private:
    float simd_dot(const float* x, const float* y, const long& len);

private:
    MNN::Interpreter* net_ = nullptr;
    MNN::Session* session_ = nullptr;
    MNN::CV::ImageProcess::Config preProcessConfig_;

    MNN::Tensor* input_;
    MNN::Tensor* output_;

    int width_;
    int height_;
    float mean_vals_[3];
    float norm_vals_[3];
    std::vector<cv::Point2f> standard_pts;
};