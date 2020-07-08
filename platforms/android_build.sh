#!/bin/bash


################################################################################
# init (export and remove potential old stuff)
################################################################################

if [ -z $ANDROID_NDK ]; then
  export ANDROID_NDK=$ANDROID_NDK_HOME
fi

if [ -z $ANDROID_SDK ]; then
  export ANDROID_SDK=$ANDROID_HOME
fi


ARM_BUILD_FOLDER="build_android_arm"
FINAL_RELEASE_FOLDER="opencv"
INSTALL_DIR_NATIVE=$ARM_BUILD_FOLDER/install/sdk/native

################################################################################
# arm64 build
################################################################################
echo "building for arm64-v8a"

ARCH="arm64-v8a"
rm -rf $ARM_BUILD_FOLDER
rm -rf $FINAL_RELEASE_FOLDER
mkdir $FINAL_RELEASE_FOLDER
mkdir $FINAL_RELEASE_FOLDER/include

scripts/cmake_android_arm.sh -DANDROID_STL=c++_shared -DBUILD_SHARED_LIBS=ON -DENABLE_LTO=ON -DBUILD_opencv_calib3d=OFF -DBUILD_opencv_dnn=OFF -DBUILD_opencv_features2d=OFF -DBUILD_opencv_flann=OFF -DBUILD_opencv_highgui=OFF -DBUILD_opencv_ml=OFF -DBUILD_opencv_objdetect=OFF -DBUILD_opencv_photo=OFF -DBUILD_opencv_stitching=OFF -DBUILD_opencv_video=OFF -DBUILD_opencv_videoio=OFF -DBUILD_opencv_videostab=OFF -DCMAKE_BUILD_TYPE=RELEASE -DBUILD_ZLIB=ON -DWITH_JAVA=ON -DANDROID_NATIVE_API_LEVEL=23 -DANDROID_ABI=$ARCH -DANDROID_TOOLCHAIN_NAME=aarch64-linux-android-4.9 -DBUILD_EXAMPLES=OFF -DBUILD_ANDROID_EXAMPLES=OFF  -DBUILD_DOCS=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF

cd $ARM_BUILD_FOLDER
make clean
make -j8
make install
cd ..

mv $INSTALL_DIR_NATIVE/jni/include/* $FINAL_RELEASE_FOLDER/include
mkdir -p $FINAL_RELEASE_FOLDER/libs/$ARCH
mv $INSTALL_DIR_NATIVE/libs/$ARCH/* $FINAL_RELEASE_FOLDER/libs/$ARCH
mkdir -p $FINAL_RELEASE_FOLDER/3rdparty/libs/$ARCH
mv $INSTALL_DIR_NATIVE/3rdparty/libs/$ARCH/* $FINAL_RELEASE_FOLDER/3rdparty/libs/$ARCH

################################################################################
# armeabi-v7a build
################################################################################
echo "building for armeabi-v7a"

ARCH="armeabi-v7a"
rm -rf $ARM_BUILD_FOLDER

scripts/cmake_android_arm.sh -DANDROID_STL=c++_shared -DBUILD_SHARED_LIBS=ON -DENABLE_LTO=ON  -DBUILD_opencv_calib3d=OFF -DBUILD_opencv_dnn=OFF -DBUILD_opencv_features2d=OFF -DBUILD_opencv_flann=OFF -DBUILD_opencv_highgui=OFF -DBUILD_opencv_ml=OFF -DBUILD_opencv_objdetect=OFF -DBUILD_opencv_photo=OFF -DBUILD_opencv_stitching=OFF -DBUILD_opencv_video=OFF -DBUILD_opencv_videoio=OFF -DBUILD_opencv_videostab=OFF -DCMAKE_BUILD_TYPE=RELEASE -DBUILD_ZLIB=ON -DWITH_JAVA=ON -DANDROID_NATIVE_API_LEVEL=23 -DANDROID_ABI=$ARCH -DANDROID_TOOLCHAIN_NAME=arm-linux-androideabi-4.9 -DBUILD_EXAMPLES=OFF -DBUILD_ANDROID_EXAMPLES=OFF  -DBUILD_DOCS=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF

cd $ARM_BUILD_FOLDER
make clean
make -j8
make install
cd ..

mkdir -p $FINAL_RELEASE_FOLDER/libs/$ARCH
mv $INSTALL_DIR_NATIVE/libs/$ARCH/* $FINAL_RELEASE_FOLDER/libs/$ARCH
mkdir -p $FINAL_RELEASE_FOLDER/3rdparty/libs/$ARCH
mv $INSTALL_DIR_NATIVE/3rdparty/libs/$ARCH/* $FINAL_RELEASE_FOLDER/3rdparty/libs/$ARCH

################################################################################
# x86 build
################################################################################
echo "building for x86"

ARCH="x86"
rm -rf $ARM_BUILD_FOLDER

scripts/cmake_android_arm.sh -DWITH_IPP=OFF -DANDROID_STL=c++_shared -DBUILD_SHARED_LIBS=ON -DENABLE_LTO=ON -DBUILD_opencv_calib3d=OFF -DBUILD_opencv_dnn=OFF -DBUILD_opencv_features2d=OFF -DBUILD_opencv_flann=OFF -DBUILD_opencv_highgui=OFF -DBUILD_opencv_ml=OFF -DBUILD_opencv_objdetect=OFF -DBUILD_opencv_photo=OFF -DBUILD_opencv_stitching=OFF -DBUILD_opencv_video=OFF -DBUILD_opencv_videoio=OFF -DBUILD_opencv_videostab=OFF -DCMAKE_BUILD_TYPE=RELEASE -DBUILD_ZLIB=ON -DWITH_JAVA=ON -DANDROID_NATIVE_API_LEVEL=23 -DANDROID_ABI=$ARCH -DANDROID_TOOLCHAIN_NAME=x86-4.9 -DBUILD_EXAMPLES=OFF -DBUILD_ANDROID_EXAMPLES=OFF  -DBUILD_DOCS=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF

cd $ARM_BUILD_FOLDER
make clean
make -j8
make install
cd ..

mkdir -p $FINAL_RELEASE_FOLDER/libs/$ARCH
mv $INSTALL_DIR_NATIVE/libs/$ARCH/* $FINAL_RELEASE_FOLDER/libs/$ARCH
mkdir -p $FINAL_RELEASE_FOLDER/3rdparty/libs/$ARCH
mv $INSTALL_DIR_NATIVE/3rdparty/libs/$ARCH/* $FINAL_RELEASE_FOLDER/3rdparty/libs/$ARCH


################################################################################
# x86_64 build
################################################################################
echo "building for x86_64"

ARCH="x86_64"
rm -rf $ARM_BUILD_FOLDER

scripts/cmake_android_arm.sh -DWITH_IPP=OFF -DANDROID_STL=c++_shared -DBUILD_SHARED_LIBS=ON -DENABLE_LTO=ON -DBUILD_opencv_calib3d=OFF -DBUILD_opencv_dnn=OFF -DBUILD_opencv_features2d=OFF -DBUILD_opencv_flann=OFF -DBUILD_opencv_highgui=OFF -DBUILD_opencv_ml=OFF -DBUILD_opencv_objdetect=OFF -DBUILD_opencv_photo=OFF -DBUILD_opencv_stitching=OFF -DBUILD_opencv_video=OFF -DBUILD_opencv_videoio=OFF -DBUILD_opencv_videostab=OFF -DCMAKE_BUILD_TYPE=RELEASE -DBUILD_ZLIB=ON -DWITH_JAVA=ON -DANDROID_NATIVE_API_LEVEL=23 -DANDROID_ABI=$ARCH -DANDROID_TOOLCHAIN_NAME=x86_64-4.9 -DBUILD_EXAMPLES=OFF -DBUILD_ANDROID_EXAMPLES=OFF  -DBUILD_DOCS=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF

cd $ARM_BUILD_FOLDER
make clean
make -j8
make install
cd ..

mkdir -p $FINAL_RELEASE_FOLDER/libs/$ARCH
mv $INSTALL_DIR_NATIVE/libs/$ARCH/* $FINAL_RELEASE_FOLDER/libs/$ARCH
mkdir -p $FINAL_RELEASE_FOLDER/3rdparty/libs/$ARCH
mv $INSTALL_DIR_NATIVE/3rdparty/libs/$ARCH/* $FINAL_RELEASE_FOLDER/3rdparty/libs/$ARCH

################################################################################
# finish
################################################################################

rm $FINAL_RELEASE_FOLDER.zip
zip -r $FINAL_RELEASE_FOLDER.zip $FINAL_RELEASE_FOLDER
echo "Created zip at: $PWD/$FINAL_RELEASE_FOLDER.zip"
exit 0
