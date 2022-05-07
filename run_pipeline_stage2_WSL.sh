#!/usr/bin/bash
#example usage: sh run_pipeline_stage2_WSL.sh example_dance /mnt/c/temp/MTC-Data-Win /mnt/c/Users/CarlM/Downloads/openpose-1.7.0-binaries-win64-gpu-python3.7-flir-3d_recommended/openpose C:/temp/MTC-Data-Win/example_dance

set -e
# input param
# $1: sequence name
# $2: path to the parent folder of the data that you want to use.
# Data would be structured as $2/example_dance/example_dance.avi
# $3: path to the openpose windows binaries root i.e. the path to the folder that contains the bin and models dirs. should be in Linux style, e.g. /mnt/c/temp...
seqName=$1
wslDataDir=$2
openPosePath=$3
windowsSequencePath=$4

if [ -z "$wslDataDir" ]
then
  wslDataDir=./data/
fi

echo "Using wslDataDir: " $wslDataDir

# convert to absolute path
MTCDir=$(readlink -f .)
wslDataDir=$(readlink -f $wslDataDir)

cd $wslDataDir/$seqName
# run OpenPose on image frames
if [ ! -d openpose_result ]; then
        echo "Running openpose"
        mkdir $wslDataDir/$seqName/openpose_result
        cd $openPosePath
        $openPosePath/bin/OpenPoseDemo.exe --face --hand --image_dir $windowsSequencePath/raw_image --write_json $windowsSequencePath/openpose_result --render_pose 0 --display 0 -model_pose BODY_25 --number_people_max 1
fi