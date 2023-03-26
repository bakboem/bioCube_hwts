#pragma

#include <MNN/ImageProcess.hpp>
#include <MNN/Interpreter.hpp>
#include <opencv2/opencv.hpp>
#include <opencv2/highgui.hpp>

struct FaceObject {
    cv::Rect_<float> rect;
    float prob;
    float landmark[10];
};

struct Anchor{
	float cx;
	float cy;
	float s_kx;
	float s_ky;
};

class Detector {
  public:
    Detector ();
    ~Detector();
    int Initial(std::string model_path, int width, int height, int device_mode, float threshold);
    int detect(cv::Mat img, std::vector<FaceObject> &faces, bool bfixsize = false);
    void SetScoreThresh(float thresh);
private:
    float intersection_area(const FaceObject& a, const FaceObject& b);
    void generate_anchors(int width, int height, std::vector<Anchor>& Anchors);
    void decode_bbox_idx(float* loc, std::vector<Anchor>& Anchors, int width, int height, int idx, FaceObject& face);
    void decode_landmark_idx(float* lmk, std::vector<Anchor>& Anchors, int width, int height, int idx, FaceObject& face);
    void nms_sorted_bboxes(const std::vector<FaceObject>& faceobjects, std::vector<int>& picked, float nms_threshold);
    int round32(int x);

  private:
    MNN::Interpreter *net_ = nullptr;
    MNN::Session *session_ = nullptr;
    MNN::CV::ImageProcess::Config preProcessConfig_;
    
    MNN::Tensor* input_;
    MNN::Tensor* loc_;
    MNN::Tensor* cls_;
    MNN::Tensor* lmk_;
    std::vector<Anchor> Anchors_;
    int width_;
    int height_;
    float mean_vals_[3];
    float conf_;
    int top_k_;
    int device_mode;
};