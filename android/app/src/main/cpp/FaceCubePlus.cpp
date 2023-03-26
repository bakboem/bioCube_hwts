#include "FaceCubePlus.h"

namespace fcp {
    FaceDetection::FaceDetection(const char* model_path, int width, int height, int device_mode, float threshold) {
        detector = new Detector();
        detector->Initial(model_path, width, height, device_mode, threshold);
    }

    FaceDetection::~FaceDetection() {
        delete detector;
    }

    FaceIdentification::FaceIdentification(const char* model_path, int device_mode) {
        recognizer = new Recognizer();
        recognizer->Initial(model_path, device_mode);
    }

    FaceIdentification::~FaceIdentification() {
        delete recognizer;
    }

    int FaceDetection::Detect(const cv::Mat img, std::vector<FaceObject>& faces, bool bfixsize) {
        if (img.empty()) {
            std::cout << "Face Detector: image is empty." << std::endl;
            return 0;
        }
        return detector->detect(img, faces, bfixsize);
    }

    void FaceDetection::SetScoreThresh(float thresh) {
        detector->SetScoreThresh(thresh);
    }

    cv::Mat FaceIdentification::CropFace(cv::Mat img, cv::Rect_<float> rect, float* points) {
        return recognizer->Crop(img, rect, points);
    }

    int FaceIdentification::ExtractFeature(cv::Mat img, float* feat) {
        if (feat == NULL) {
            std::cout << "Face Recognizer: 'feats' must be initialized with size \
           of GetFeatureSize(). " << std::endl;
            return 0;
        }
        recognizer->Recognize(img, feat);
        return 1;
    }

    float FaceIdentification::CalcSimilarity(float* fc1, float* fc2, long dim) {
        return recognizer->CalcSimilarity(fc1, fc2, dim);
    }
}
