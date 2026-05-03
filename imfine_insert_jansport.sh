export CUDA_VISIBLE_DEVICES=1

source_path="/workspace/hana/Infusion/data/imfine/jansport"
model_path="/workspace/hana/Infusion/output_insert/imfine/jansport"

# cd gaussian_splatting
# python train.py -s $source_path -m $model_path -u nothing --mask_training --color_aug

# python render.py -s $source_path -m $model_path -u nothing

# cd ../


# input_rgb_path="/workspace/hana/Infusion/frame_00051.png"
# input_mask_path="/workspace/hana/Infusion/mask.png"
# input_depth_path="/workspace/hana/Infusion/output_insert/imfine/jansport/train/ours_30000/depth_dis/frame_00051.npy"
# c2w="/workspace/hana/Infusion/output_insert/imfine/jansport/train/ours_30000/c2w/frame_00051.npy"
# intri="/workspace/hana/Infusion/output_insert/imfine/jansport/train/ours_30000/intri/frame_00051.npy"
# model_path="/workspace/hana/Infusion/checkpoints/Infusion"
# output_dir="/workspace/hana/Infusion/output_insert/imfine/jansport/pred_depth"

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

# cd ../../

origin_ply="/workspace/hana/Infusion/output_insert/imfine/jansport/point_cloud/iteration_30000/point_cloud.ply"
supp_ply="/workspace/hana/Infusion/output_insert/imfine/jansport/pred_depth/frame_00051_mask.ply"
save_ply="/workspace/hana/Infusion/output_insert/imfine/jansport/point_cloud/iteration_30001/point_cloud.ply"

# python compose.py --original_ply $origin_ply  --supp_ply $supp_ply --save_ply $save_ply --nb_points 100 --threshold 1.0

cd gaussian_splatting
# python train.py -s $source_path -m $model_path -u frame_00051.png -n /workspace/hana/Infusion/frame_00051.png --load_iteration 30001 --iteration 150

python render.py -s $source_path -m $model_path -u nothing --iteration 150