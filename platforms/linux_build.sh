#!/bin/bash


################################################################################
# init (export and remove potential old stuff)
################################################################################
LINUX_BUILD_FOLDER="build_linux"
FINAL_RELEASE_FOLDER="opencv_linux"
INSTALL_DIR_NATIVE=lib

rm -rf $LINUX_BUILD_FOLDER
rm -rf $FINAL_RELEASE_FOLDER
mkdir $FINAL_RELEASE_FOLDER
mkdir $FINAL_RELEASE_FOLDER/include

scripts/cmake_linux.sh -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR_NATIVE -DBUILD_SHARED_LIBS=ON -DENABLE_LTO=ON -DBUILD_opencv_calib3d=OFF -DBUILD_opencv_dnn=OFF -DBUILD_opencv_features2d=OFF -DBUILD_opencv_flann=OFF -DBUILD_opencv_highgui=OFF -DBUILD_opencv_ml=OFF -DBUILD_opencv_objdetect=OFF -DBUILD_opencv_photo=OFF -DBUILD_opencv_stitching=OFF -DBUILD_opencv_video=OFF -DBUILD_opencv_videoio=OFF -DBUILD_opencv_videostab=OFF -DCMAKE_BUILD_TYPE=RELEASE -DBUILD_ZLIB=ON -DBUILD_EXAMPLES=OFF -DBUILD_ANDROID_EXAMPLES=OFF  -DBUILD_DOCS=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF

cd $LINUX_BUILD_FOLDER
make clean
make -j8
make install
cd ..

mv $LINUX_BUILD_FOLDER/$INSTALL_DIR_NATIVE/include/* $FINAL_RELEASE_FOLDER/include
mkdir -p $FINAL_RELEASE_FOLDER/libs/
mv $LINUX_BUILD_FOLDER/$INSTALL_DIR_NATIVE/*.so.* $FINAL_RELEASE_FOLDER/libs

################################################################################
# finish
################################################################################

rm $FINAL_RELEASE_FOLDER.zip
zip -r $FINAL_RELEASE_FOLDER.zip $FINAL_RELEASE_FOLDER
echo "Created zip at: $PWD/$FINAL_RELEASE_FOLDER.zip"
exit 0