#!/usr/bin/bash

set -e
# input param 
# $1: sequence name
# $2: path to the parent folder of the data that you want to use.
# Data would be structured as $2/example_dance/example_dance.avi
# $3: whether the video is upper body only (false by default, enable by -f)
seqName=$1
dataDir=$2
openPoseDir=$3

if [ -z "$dataDir" ]
then
  dataDir=./data/
fi

if [ -z "$openposeDir" ]
then
  openposeDir=../openpose/
fi

echo "Using dataDir: " $dataDir

# Git clone openpose to ../openpose and compile with cmake
openposeDir=../openpose/

# convert to absolute path
MTCDir=$(readlink -f .)
dataDir=$(readlink -f $dataDir)
openposeDir=$(readlink -f $openposeDir)

# run OpenPose on image frames
if [ ! -d openpose_result ]; then
	mkdir openpose_result
	cd $openposeDir
	./build/examples/openpose/openpose.bin --face --hand --image_dir $dataDir/$seqName/raw_image --write_json $dataDir/$seqName/openpose_result --render_pose 0 --display 0 -model_pose BODY_25 --number_people_max 1
fi
