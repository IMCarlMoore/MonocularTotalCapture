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

# merge openpose results into a single file
cd $MTCDir
numFrame=$(ls $dataDir/$seqName/openpose_result/$seqName_* | wc -l)
python3 POF/collect_openpose.py -n $seqName -r $dataDir/$seqName -c $numFrame

# run POF generation code
cd POF
if [ ! -d $dataDir/$seqName/net_output/ ]; then
	python3.4 save_total_sequence.py -s $seqName -p $dataDir/$seqName $upperBody
	# python3 save_total_sequence.py -s $seqName -p $dataDir/$seqName --end-index 10 $upperBody
else
	echo "POF results exist. Skip POF generation."
fi

# run Adam Fitting
cd $MTCDir/FitAdam/
if [ ! -f ./build/run_fitting ]; then
	echo "C++ project not correctly compiled. Please check your setting."
fi
./build/run_fitting --root_dirs $dataDir --seqName $seqName --start 1 --end $((numFrame + 1)) --stage 1 --imageOF
# ./build/run_fitting --root_dirs $dataDir --seqName $seqName --start 1 --end 11 --stage 1 --imageOF
