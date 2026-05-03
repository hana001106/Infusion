
from scene.dataset_readers import CameraInfo
from scene.colmap_loader import read_extrinsics_text, read_intrinsics_text, qvec2rotmat, \
    read_extrinsics_binary, read_intrinsics_binary, read_points3D_binary, read_points3D_text
from utils.graphics_utils import getWorld2View2, focal2fov, fov2focal
import os
from scene.cameras import Camera
import sys
import numpy as np
from gaussian_renderer import render
from PIL import Image
from utils.general_utils import PILtoTorch

def novel_view(colmap_nv, remove_path):
    # colmap_nv = conf["render"]["render_nv"]
    ## in dataset_readers
    try:
        cameras_extrinsic_file = os.path.join(colmap_nv, "images.bin")
        cameras_intrinsic_file = os.path.join(colmap_nv, "cameras.bin")
        cam_extrinsics = read_extrinsics_binary(cameras_extrinsic_file)
        cam_intrinsics = read_intrinsics_binary(cameras_intrinsic_file)
    except:
        cameras_extrinsic_file = os.path.join(colmap_nv, "images.txt")
        cameras_intrinsic_file = os.path.join(colmap_nv, "cameras.txt")
        cam_extrinsics = read_extrinsics_binary(cameras_extrinsic_file)
        cam_intrinsics = read_intrinsics_binary(cameras_intrinsic_file)
    cam_infos = []
    for idx, key in enumerate(cam_extrinsics):
        sys.stdout.write('\r')
        # the exact output you're looking for:
        sys.stdout.write("Reading camera {}/{}".format(idx+1, len(cam_extrinsics)))
        sys.stdout.flush()

        extr = cam_extrinsics[key]
        intr = cam_intrinsics[extr.camera_id]
        height = intr.height
        width = intr.width
        image_name = extr.name
        ## for ext
        image_name = os.path.basename(image_name).split(".")[0]+".png"

        uid = intr.id
        R = np.transpose(qvec2rotmat(extr.qvec))
        T = np.array(extr.tvec)

        # if intr.model=="SIMPLE_PINHOLE":
        print(' intr.model: ', intr.model)
        if intr.model=="SIMPLE_PINHOLE" or intr.model == "SIMPLE_RADIAL":
            focal_length_x = intr.params[0]
            FovY = focal2fov(focal_length_x, height)
            FovX = focal2fov(focal_length_x, width)
            cx = intr.params[1]
            cy = intr.params[2]

        elif intr.model=="PINHOLE":
            focal_length_x = intr.params[0]
            focal_length_y = intr.params[1]
            FovY = focal2fov(focal_length_y, height)
            FovX = focal2fov(focal_length_x, width)
        else:
            assert False, "Colmap camera model not handled: only undistorted datasets (PINHOLE or SIMPLE_PINHOLE cameras) supported!"
        if os.path.exists(os.path.join(remove_path, image_name)):
            image = Image.open(os.path.join(remove_path, image_name))
            image = PILtoTorch(image, (image.size[0], image.size[1]))
        else:
            image = None
        cam_info = CameraInfo(uid=uid, R=R, T=T, FovY=FovY, FovX=FovX, image=image, image_mask=None, image_path=None, image_name=image_name, width=width, height=height)

        cam_infos.append(cam_info)
    # sys.stdout.write("\n")
    sorted_cam_infos = sorted(cam_infos.copy(), key = lambda x : x.image_name)
    camera_list = []

    for id, cam in enumerate(sorted_cam_infos):
        camera = Camera(colmap_id=cam.uid, R=cam.R, T=cam.T, 
                        FoVx=cam.FovX, FoVy=cam.FovY, 
                        image=cam.image,  gt_alpha_mask=None, image_mask=None, image_name=cam.image_name, uid=id, data_device="cuda")

        camera_list.append(camera)

    return camera_list
