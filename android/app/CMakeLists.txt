cmake_minimum_required(VERSION 3.18.1)
project(hwst)
# add_library(lib_opencv SHARED IMPORTED)
# set_target_properties(lib_opencv PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/src/main/jniLibs/${ANDROID_ABI}/libopencv_java4.so)

# add_library(libMNN SHARED IMPORTED)
# set_target_properties(libMNN PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/src/main/jniLibs/${ANDROID_ABI}/libMNN.so)

# find_library(log-lib log)

# add_library(native_opencv SHARED ${CMAKE_CURRENT_SOURCE_DIR}/src/main/cpp/native_opencv.cpp ${CMAKE_CURRENT_SOURCE_DIR}/src/main/cpp/detector.cpp ${CMAKE_CURRENT_SOURCE_DIR}/src/main/cpp/recognizer.cpp ${CMAKE_CURRENT_SOURCE_DIR}/src/main/cpp/FaceCubePlus.cpp)
# include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src/main/cpp/include)
# target_link_libraries(native_opencv lib_opencv libMNN ${log-lib})

set(pathOPENCV /Users/bakbeom/Documents/bioCubeLib/hwts/opencvAndMnn/OpenCV-android-sdk/sdk)
set(pathLIBOPENCV_JAVA ${pathOPENCV}/native/libs/${ANDROID_ABI}/libopencv_java4.so)

set(CMAKE_VERBOSE_MAKEFILE on)
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
include_directories(${pathOPENCV}/native/jni/include)

add_library(libMNN SHARED IMPORTED)
set_target_properties(libMNN PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/libs/${ANDROID_ABI}/libMNN.so)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src/main/cpp/includes)


add_library(native_opencv SHARED ${CMAKE_CURRENT_SOURCE_DIR}/src/main/cpp/native_opencv.cpp ${CMAKE_CURRENT_SOURCE_DIR}/src/main/cpp/detector.cpp ${CMAKE_CURRENT_SOURCE_DIR}/src/main/cpp/recognizer.cpp ${CMAKE_CURRENT_SOURCE_DIR}/src/main/cpp/FaceCubePlus.cpp)

add_library(lib_opencv SHARED IMPORTED)
set_target_properties(lib_opencv PROPERTIES IMPORTED_LOCATION ${pathLIBOPENCV_JAVA})

find_library(log-lib log)
target_link_libraries(native_opencv lib_opencv libMNN ${log-lib})