#!/bin/bash

mvn deploy:deploy-file -DgroupId=org.opencv.android.framework \
    -DartifactId=opencv-image-processing \
    -Dversion=3.3.0 \
    -Dpackaging=zip \
    -Dfile=opencv.zip \
    -DgeneratePom=true \
    -DrepositoryId=releases-extern \
    -Durl=http://dev2/nexus/repository/ld-third-party-releases \