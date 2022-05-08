import argparse
import os

def WindowsPathToWSLPath(path):
  path = path.replace(path[0]+':', path[0].lower() + ':')
  path = path.replace(r':', r'')
  path = '/mnt/' + path
  path = path.replace('\\', '/')

  return path

def RunStages(args):
    dataDirWSL = WindowsPathToWSLPath(args.dataDir)
    sequenceName = 'example_dance'
    dockerWSLRunCommand = f'wsl docker run --gpus all -v {dataDirWSL}:/data -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY -e XAUTHORITY -e NVIDIA_DRIVER_CAPABILITIES=all mtc'
    runStage1WSLCommand = f'sh ./run_pipeline_stage1.sh {sequenceName} /data'

    fullStage1Command = dockerWSLRunCommand + ' ' + runStage1WSLCommand
    os.system(fullStage1Command)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--dataDir', required=True, help='Path to the folder that contains sequence folders. e.g. dataDir\example_dance\example_dance.avi')
    parser.add_argument('--sequenceName', help='Name of the sequence used in the folder and file name, e.g. example_dance')
    parser.add_argument('--pathToOpenposeDir', required=True, help='Path to openpose root, containing bin and models folder.')

    args = parser.parse_args()

    RunStages(args)

if __name__ == '__main__':
  main()
