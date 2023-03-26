#pragma once
#include "detector.h"
#include "recognizer.h"

namespace fcp {
    class FaceIdentification {
    public:
        FaceIdentification(const char* model_path, int device_mode);

        ~FaceIdentification();

        cv::Mat CropFace(cv::Mat img, cv::Rect_<float> rect, float* points);

        // Extract feature with a cropping face.
        // 'feats' must be initialized with size of feature_size().
        int ExtractFeature(cv::Mat img, float* feat);

        // Calculate similarity of face features fc1 and fc2.
        // dim = -1 default feature size
        float CalcSimilarity(float* fc1, float* fc2, long dim = 512);

    private:
        Recognizer* recognizer;
    };

    class FaceDetection {
    public:
        FaceDetection(const char* model_path, int width, int height, int device_mode, float threshold);
        ~FaceDetection();

        int Detect(const cv::Mat img, std::vector<FaceObject>& faces, bool bfixsize=false);

        void SetScoreThresh(float thresh);

    private:
        Detector* detector;
    };
}