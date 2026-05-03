export CUDA_VISIBLE_DEVICES=1

source_path="/workspace/hana/Infusion/data/imfine/bucket"
model_path="/workspace/hana/Infusion/output_insert/imfine/bucket"

cd gaussian_splatting
python train.py -s $source_path -m $model_path -u nothing --mask_training --color_aug

python render.py -s $source_path -m $model_path -u nothing

cd ../


input_rgb_path="/workspace/hana/Infusion/frame_00237.png"
input_mask_path="/workspace/hana/Infusion/mask.png"
input_depth_path="/workspace/hana/Infusion/output_insert/imfine/bucket/train/ours_30000/depth_dis/frame_00237.npy"
c2w="/workspace/hana/Infusion/output_insert/imfine/bucket/train/ours_30000/c2w/frame_00237.npy"
intri="/workspace/hana/Infusion/output_insert/imfine/bucket/train/ours_30000/intri/frame_00237.npy"
ckpt_path="/workspace/hana/Infusion/checkpoints/Infusion"
output_dir="/workspace/hana/Infusion/output_insert/imfine/bucket/pred_depth"

cd depth_inpainting/run

python run_inference_inpainting.py \
            --input_rgb_path $input_rgb_path \
            --input_mask $input_mask_path \
            --input_depth_path $input_depth_path \
            --model_path $ckpt_path \
            --output_dir $output_dir \
            --denoise_steps 20 \
            --intri $intri \
            --c2w $c2w \
            --use_mask

cd ../../

origin_ply="/workspace/hana/Infusion/output_insert/imfine/bucket/point_cloud/iteration_30000/point_cloud.ply"
supp_ply="/workspace/hana/Infusion/output_insert/imfine/bucket/pred_depth/frame_00237_mask.ply"
save_ply="/workspace/hana/Infusion/output_insert/imfine/bucket/point_cloud/iteration_30001/point_cloud.ply"

python compose.py --original_ply $origin_ply  --supp_ply $supp_ply --save_ply $save_ply --nb_points 100 --threshold 1.0

cd gaussian_splatting
python train.py -s $source_path -m $model_path -u frame_00237.png -n /workspace/hana/Infusion/frame_00237.png --load_iteration 30001 --iteration 150

python render.py -s $source_path -m $model_path -u nothing --iteration 150