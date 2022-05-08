#!/usr/bin/bash

set -e
# input param 
# $1: sequence name
# $2: path to the parent folder of the data that you want to use.
# Data would be structured as $2/example_dance/example_dance.avi
# $3: whether the video is upper body only (false by default, enable by -f)
seqName=$1
dataDir=$2
upperBody=$3

if [ -z "$dataDir" ]
then
  dataDir=./data/
fi

echo "Using dataDir: " $dataDir

# convert to absolute path
MTCDir=$(readlink -f .)
dataDir=$(readlink -f $dataDir)

if [ ! -f $dataDir/$seqName/calib.json ]; then
	echo "Camera intrinsics not specified, use default."
	cp -v POF/calib.json $dataDir/$seqName
fi

# use ffmpeg to extract image frames
cd $dataDir/$seqName
if [ ! -d raw_image ]; then
	mkdir raw_image
	ffmpeg -i $seqName.mp4 raw_image/${seqName}_%08d.png
fi