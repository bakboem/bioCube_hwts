#include "detector.h"

#define CPU 1
#define GPU 2

Detector::Detector() {
}

Detector::~Detector() {
    if (net_ != nullptr) {
        net_->releaseModel();
        net_->releaseSession(session_);
    }
    Anchors_.clear();
}

int Detector::Initial(std::string model_path, int width, int height, int device_mode, float threshold) {
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
    cls_ = net_->getSessionOutput(session_, "586");
    loc_ = net_->getSessionOutput(session_, "511");
    lmk_ = net_->getSessionOutput(session_, "585");

    width_ = round32(width);
    height_ = round32(height);
    net_->resizeTensor(input_, { 1, 3, height_, width_ });
    net_->resizeSession(session_);
    
    mean_vals_[0] = 104.0f;
    mean_vals_[1] = 117.0f;
    mean_vals_[2] = 123.0f;

    ::memcpy(preProcessConfig_.mean, mean_vals_, sizeof(mean_vals_));
    preProcessConfig_.sourceFormat = MNN::CV::BGR;
    preProcessConfig_.destFormat = MNN::CV::RGB;

    conf_ = threshold;
    top_k_ = 100;
    generate_anchors(width_, height_, Anchors_);

    return 0;
}

void Detector::SetScoreThresh(float thresh) {
    conf_ = thresh;
}

float Detector::intersection_area(const FaceObject& a, const FaceObject& b) {
    cv::Rect_<float> inter = a.rect & b.rect;
    return inter.area();
}

void Detector::generate_anchors(int width, int height, std::vector<Anchor>& Anchors) {
    int steps[3] = { 8,16,32 };
    int min_sizes[3][2] = { {16,32},{64,128},{256,512} };
    int feature_maps[3][2] = { 0 };
    for (int i = 0; i < 3; i++) {
        feature_maps[i][0] = ceil(height * 1.0 / steps[i]);
        feature_maps[i][1] = ceil(width * 1.0 / steps[i]);
    }
    Anchors.clear();
    for (int i = 0; i < 3; i++) {
        int* min_size = min_sizes[i];
        for (int id_y = 0; id_y < feature_maps[i][0]; id_y++) {
            for (int id_x = 0; id_x < feature_maps[i][1]; id_x++)
                for (int k = 0; k < 2; k++) {
                    float s_kx = min_size[k] * 1.0 / width;
                    float s_ky = min_size[k] * 1.0 / height;
                    float dense_cx = (id_x + 0.5) * steps[i] / width;
                    float dense_cy = (id_y + 0.5) * steps[i] / height;
                    Anchor a;
                    a.cx = dense_cx;
                    a.cy = dense_cy;
                    a.s_kx = s_kx;
                    a.s_ky = s_ky;
                    Anchors.push_back(a);
                }
        }
    }
}

void Detector::decode_bbox_idx(float* loc, std::vector<Anchor>& Anchors, int width, int height, int idx, FaceObject &face) {
    float variance[2] = { 0.1,0.2 };
    float x0 = Anchors[idx].cx + loc[idx * 4] * variance[0] * Anchors[idx].s_kx;
    float y0 = Anchors[idx].cy + loc[idx * 4 + 1] * variance[0] * Anchors[idx].s_ky;

    float bbox_w = (Anchors[idx].s_kx * exp(loc[idx * 4 + 2] * variance[1])) * width;  //width
    float bbox_h = (Anchors[idx].s_ky * exp(loc[idx * 4 + 3] * variance[1])) * height;  //height
    x0 = x0 * width - bbox_w / 2;          //x0
    y0 = y0 * height - bbox_h / 2;      //y0
    face.rect.x = x0;
    face.rect.y = y0;
    face.rect.width = bbox_w;
    face.rect.height = bbox_h;
}

void Detector::decode_landmark_idx(float* lmk, std::vector<Anchor>& Anchors, int width, int height, int idx, FaceObject& face) {
    float variance[2] = { 0.1,0.2 };
    for (int l = 0; l < 10; l++) {
        if (l % 2 == 0) {
            face.landmark[l] = Anchors[idx].cx + lmk[idx * 10 + l] * variance[0] * Anchors[idx].s_kx;
            face.landmark[l] *= width;
        }
        else {
            face.landmark[l] = Anchors[idx].cy + lmk[idx * 10 + l] * variance[0] * Anchors[idx].s_ky;
            face.landmark[l] *= height;
        }
    }
}

void Detector::nms_sorted_bboxes(const std::vector<FaceObject>& faceobjects, std::vector<int>& picked, float nms_threshold) {
    picked.clear();
    const int n = faceobjects.size();
    std::vector<float> areas(n);
    for (int i = 0; i < n; i++) {
        areas[i] = faceobjects[i].rect.area();
    }
    for (int i = 0; i < n; i++) {
        const FaceObject& a = faceobjects[i];
        int keep = 1;
        for (int j = 0; j < (int)picked.size(); j++) {
            const FaceObject& b = faceobjects[picked[j]];
            // intersection over union
            float inter_area = intersection_area(a, b);
            float union_area = areas[i] + areas[picked[j]] - inter_area;
            //float IoU = inter_area / union_area
            if (inter_area / union_area > nms_threshold)
                keep = 0;
        }
        if (keep)
            picked.push_back(i);
    }
}

bool FaceLargerScore(FaceObject  a, FaceObject b) {
    if (a.prob > b.prob) {
        return true;
    }
    else {
        return false;
    }
}

int Detector::round32(int x) {
    x = int((x / 32) + 0.5) * 32;
    return x;
}

int Detector::detect(const cv::Mat img, std::vector<FaceObject>& faces, bool bfixsize) {
    if (bfixsize == false && device_mode == CPU) {
        if (width_ != round32(img.cols) || height_ != round32(img.rows)) {
            width_ = round32(img.cols);
            height_ = round32(img.rows);
            generate_anchors(width_, height_, Anchors_);
        }
    }
    cv::Mat bgr;
    cv::resize(img, bgr, cv::Size(width_, height_));
    net_->resizeTensor(input_, { 1, 3, height_, width_ });
    net_->resizeSession(session_);

    MNN::CV::ImageProcess* pretreat_ = MNN::CV::ImageProcess::create(preProcessConfig_);
    pretreat_->convert(bgr.data, width_, height_, bgr.step[0], input_);
    net_->runSession(session_);

    MNN::Tensor clsHost(cls_, MNN::Tensor::CAFFE);
    MNN::Tensor locHost(loc_, MNN::Tensor::CAFFE);
    MNN::Tensor lmkHost(lmk_, MNN::Tensor::CAFFE);

    cls_->copyToHostTensor(&clsHost);
    loc_->copyToHostTensor(&locHost);
    lmk_->copyToHostTensor(&lmkHost);

    std::vector<int> shape0 = clsHost.shape();
    std::vector<int> shape3 = lmkHost.shape();

    int c = shape0[0];
    int length = shape0[1];
    //printf("%d\n", length);
    auto cls_data = clsHost.host<float>();
    auto loc_data = locHost.host<float>();
    auto lmk_data = lmkHost.host<float>();

    std::vector<FaceObject> tempfaces, temphands;
    for (int q = 0; q < c; q++) {
        for (int y = 0; y < length; y++) {
            if (cls_data[2 * y + 1] > conf_) {
                FaceObject face;
                face.prob = cls_data[2 * y + 1];
                decode_bbox_idx(loc_data, Anchors_, width_, height_, y, face);
                decode_landmark_idx(lmk_data, Anchors_, width_, height_, y, face);
                tempfaces.push_back(face);
            }
        }
    }

    std::sort(tempfaces.begin(), tempfaces.end(), FaceLargerScore);
    if (tempfaces.size() > top_k_)
        tempfaces.resize(top_k_);

    std::vector<int> picked;
    nms_sorted_bboxes(tempfaces, picked, 0.4);

    float scale_x = img.cols * 1.0 / width_;
    float scale_y = img.rows * 1.0 / height_;

    for (int i = 0; i < picked.size(); i++) {
        FaceObject face = tempfaces[picked[i]];
        face.rect.x = face.rect.x * scale_x;
        face.rect.y = face.rect.y * scale_y;
        face.rect.width = face.rect.width * scale_x;
        face.rect.height = face.rect.height * scale_y;
        for (int l = 0; l < 10; l++) {
            if (l % 2 == 0) {
                face.landmark[l] = face.landmark[l] * scale_x;
            }
            else {
                face.landmark[l] = face.landmark[l] * scale_y;
            }
        }
        faces.push_back(face);
    }
    return 0;
}
