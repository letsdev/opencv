# NDK v27c used

export ANT_HOME=/usr/local/bin/ant
export ANDROID_NDK=$ANDROID_NDK_HOME
export ANDROID_SDK=$ANDROID_HOME
export ANDROID_SDK_ROOT=$ANDROID_HOME
export ANDROID_NATIVE_API_LEVEL=26
export STRIP=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin/llvm-strip

rm -rf build
mkdir -p build
cd build

cmake -D ANT_EXECUTABLE:FILEPATH=$ANT_HOME -DCMAKE_SHARED_LINKER_FLAGS="-Wl" -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake -DANDROID_TOOLCHAIN=clang++ -D CMAKE_BUILD_TYPE=Release -D ANDROID_NATIVE_API_LEVEL=$ANDROID_NATIVE_API_LEVEL -DENABLE_LTO=ON -DBUILD_opencv_calib3d=OFF -DBUILD_opencv_dnn=OFF -DBUILD_opencv_features2d=OFF -D BUILD_opencv_flann=OFF -D WITH_CUDA=OFF -D WITH_MATLAB=OFF -DBUILD_EXAMPLES=OFF -DBUILD_ANDROID_EXAMPLES=OFF -D BUILD_DOCS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_TESTS=OFF -D ANDROID_STL=c++_shared -D BUILD_SHARED_LIBS=ON -D BUILD_opencv_objdetect=OFF -D BUILD_opencv_video=OFF -D BUILD_opencv_videoio=OFF -D BUILD_opencv_highgui=OFF -D BUILD_opencv_ml=OFF -D BUILD_opencv_photo=OFF -D BUILD_opencv_python=OFF -D BUILD_opencv_shape=OFF -D BUILD_opencv_stitching=OFF -D BUILD_opencv_superres=OFF -D BUILD_opencv_ts=OFF -D BUILD_opencv_videostab=OFF -D BUILD_opencv_gapi=OFF -DBUILD_ZLIB=ON -DWITH_JAVA=ON -D WITH_TIFF=OFF -D WITH_WEBP=OFF -DWITH_FFMPEG=OFF -DBUILD_ANDROID_PROJECTS=OFF -DWITH_ANDROID=OFF ../../.. -DANDROID_ABI=arm64-v8a
#cmake -D ANT_EXECUTABLE:FILEPATH=$ANT_HOME -DCMAKE_SHARED_LINKER_FLAGS="-Wl" -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake -DANDROID_TOOLCHAIN=clang++ -D CMAKE_BUILD_TYPE=Release -D ANDROID_NATIVE_API_LEVEL=$ANDROID_NATIVE_API_LEVEL -DENABLE_LTO=ON -DBUILD_opencv_calib3d=OFF -DBUILD_opencv_dnn=OFF -DBUILD_opencv_features2d=OFF -D BUILD_opencv_flann=OFF -D WITH_CUDA=OFF -D WITH_MATLAB=OFF -DBUILD_EXAMPLES=OFF -DBUILD_ANDROID_EXAMPLES=OFF -D BUILD_DOCS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_TESTS=OFF -D ANDROID_STL=c++_shared -D BUILD_SHARED_LIBS=ON -D BUILD_opencv_objdetect=OFF -D BUILD_opencv_video=OFF -D BUILD_opencv_videoio=OFF -D BUILD_opencv_highgui=OFF -D BUILD_opencv_ml=OFF -D BUILD_opencv_photo=OFF -D BUILD_opencv_python=OFF -D BUILD_opencv_shape=OFF -D BUILD_opencv_stitching=OFF -D BUILD_opencv_superres=OFF -D BUILD_opencv_ts=OFF -D BUILD_opencv_videostab=OFF -D BUILD_opencv_gapi=OFF -DBUILD_ZLIB=ON -DWITH_JAVA=ON -D WITH_TIFF=OFF -D WITH_WEBP=OFF -DWITH_FFMPEG=OFF -DBUILD_ANDROID_PROJECTS=OFF -DWITH_ANDROID=OFF ../../.. -DANDROID_ABI=armeabi-v7a
#cmake -D ANT_EXECUTABLE:FILEPATH=$ANT_HOME -DCMAKE_SHARED_LINKER_FLAGS="-Wl" -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake -DANDROID_TOOLCHAIN=clang++ -D CMAKE_BUILD_TYPE=Release -D ANDROID_NATIVE_API_LEVEL=$ANDROID_NATIVE_API_LEVEL -DENABLE_LTO=ON -DBUILD_opencv_calib3d=OFF -DBUILD_opencv_dnn=OFF -DBUILD_opencv_features2d=OFF -D BUILD_opencv_flann=OFF -D WITH_CUDA=OFF -D WITH_MATLAB=OFF -DBUILD_EXAMPLES=OFF -DBUILD_ANDROID_EXAMPLES=OFF -D BUILD_DOCS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_TESTS=OFF -D ANDROID_STL=c++_shared -D BUILD_SHARED_LIBS=ON -D BUILD_opencv_objdetect=OFF -D BUILD_opencv_video=OFF -D BUILD_opencv_videoio=OFF -D BUILD_opencv_highgui=OFF -D BUILD_opencv_ml=OFF -D BUILD_opencv_photo=OFF -D BUILD_opencv_python=OFF -D BUILD_opencv_shape=OFF -D BUILD_opencv_stitching=OFF -D BUILD_opencv_superres=OFF -D BUILD_opencv_ts=OFF -D BUILD_opencv_videostab=OFF -D BUILD_opencv_gapi=OFF -DBUILD_ZLIB=ON -DWITH_JAVA=ON -D WITH_TIFF=OFF -D WITH_WEBP=OFF -DWITH_FFMPEG=OFF -DBUILD_ANDROID_PROJECTS=OFF -DWITH_ANDROID=OFF -D OPENCV_IPP_SKIP_DOWNLOAD=ON -DBUILD_IPP=OFF ../../.. -DANDROID_ABI=x86
#cmake -D ANT_EXECUTABLE:FILEPATH=$ANT_HOME -DCMAKE_SHARED_LINKER_FLAGS="-Wl" -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake -DANDROID_TOOLCHAIN=clang++ -D CMAKE_BUILD_TYPE=Release -D ANDROID_NATIVE_API_LEVEL=$ANDROID_NATIVE_API_LEVEL -DENABLE_LTO=ON -DBUILD_opencv_calib3d=OFF -DBUILD_opencv_dnn=OFF -DBUILD_opencv_features2d=OFF -D BUILD_opencv_flann=OFF -D WITH_CUDA=OFF -D WITH_MATLAB=OFF -DBUILD_EXAMPLES=OFF -DBUILD_ANDROID_EXAMPLES=OFF -D BUILD_DOCS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_TESTS=OFF -D ANDROID_STL=c++_shared -D BUILD_SHARED_LIBS=ON -D BUILD_opencv_objdetect=OFF -D BUILD_opencv_video=OFF -D BUILD_opencv_videoio=OFF -D BUILD_opencv_highgui=OFF -D BUILD_opencv_ml=OFF -D BUILD_opencv_photo=OFF -D BUILD_opencv_python=OFF -D BUILD_opencv_shape=OFF -D BUILD_opencv_stitching=OFF -D BUILD_opencv_superres=OFF -D BUILD_opencv_ts=OFF -D BUILD_opencv_videostab=OFF -D BUILD_opencv_gapi=OFF -DBUILD_ZLIB=ON -DWITH_JAVA=ON -D WITH_TIFF=OFF -D WITH_WEBP=OFF -DWITH_FFMPEG=OFF -DBUILD_ANDROID_PROJECTS=OFF -DWITH_ANDROID=OFF ../../.. -DANDROID_ABI=x86_64

make clean
make -j8
#make VERBOSE=1
make install

# STRIPPEN:
#$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin/llvm-strip --strip-unneeded libopencv_core.so libopencv_imgcodecs.so libopencv_imgproc.so libopencv_java4.so

# SONAME HANDLING:
#objdump -p  libopencv_java4.so | grep SONAME
#patchelf --set-soname libopencv_java4.so libopencv_java4.so
