mkdir %2/openpose_result
%1 --face --hand --image_dir %2/raw_image --write_json %2/openpose_result --render_pose 0 --display 0 -model_pose BODY_25 --number_people_max 1