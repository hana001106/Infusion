export CUDA_VISIBLE_DEVICES=1
# cd gaussian_splatting
# python train.py -s /workspace/hana/Infusion/data/spinnerf/1 -m /workspace/hana/Infusion/output_remove/spinnerf/1 -u nothing --mask_training --color_aug

# python render.py -s /workspace/hana/Infusion/data/spinnerf/1 -m /workspace/hana/Infusion/output_remove/spinnerf/1 -u nothing

# cd ../


# input_rgb_path="/workspace/hana/Infusion/20220819_104429_remove.png"
# input_mask_path="/workspace/hana/Infusion/mask.png"
# input_depth_path="/workspace/hana/Infusion/output_remove/spinnerf/1/train/ours_30000/depth_dis/20220819_104429.npy"
# c2w="/workspace/hana/Infusion/output_remove/spinnerf/1/train/ours_30000/c2w/20220819_104429.npy"
# intri="/workspace/hana/Infusion/output_remove/spinnerf/1/train/ours_30000/intri/20220819_104429.npy"
# model_path="/workspace/hana/Infusion/checkpoints/Infusion"
# output_dir="/workspace/hana/Infusion/output_remove/spinnerf/1/pred_depth"

# cd depth_inpainting/run

# python run_inference_inpainting.py \
#             --input_rgb_path $input_rgb_path \
#             --input_mask $input_mask_path \
#             --input_depth_path $input_depth_path \
#             --model_path $model_path \
#             --output_dir $output_dir \
#             --denoise_steps 20 \
#             --intri $intri \
#             --c2w $c2w \
#             --use_mask

# origin_ply="/workspace/hana/Infusion/output_remove/spinnerf/1/point_cloud/iteration_30000/point_cloud.ply"
# supp_ply="/workspace/hana/Infusion/output_remove/spinnerf/1/pred_depth/20220819_104429_mask.ply"
# save_ply="/workspace/hana/Infusion/output_remove/spinnerf/1/point_cloud/iteration_30001/point_cloud.ply"

# python compose.py --original_ply $origin_ply  --supp_ply $supp_ply --save_ply $save_ply --nb_points 100 --threshold 1.0

cd gaussian_splatting
# python train.py -s /workspace/hana/Infusion/data/spinnerf/1 -m /workspace/hana/Infusion/output_remove/spinnerf/1 -u 20220819_104429.png -n /workspace/hana/Infusion/20220819_104429.png --load_iteration 30001 --iteration 150

python render.py -s /workspace/hana/Infusion/data/spinnerf/1 -m /workspace/hana/Infusion/output_remove/spinnerf/1 -u nothing --iteration 150 --skip_train --skip_test --render_nv