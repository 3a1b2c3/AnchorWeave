@echo off

set TORCH_CUDA_ARCH_LIST=8.0

rem ========== Configuration ==========
set ROOT=%~dp0..
set MODEL_PATH=%ROOT%\pretrained\CogVideoX-5b-I2V

set processed_data_name=example_dataset
set ckpt_steps=8500
set ckpt_dir=%ROOT%\out\AnchorWeave_pretrained
set ckpt_file=checkpoint-%ckpt_steps%.pt
set ckpt_path=%ckpt_dir%\%ckpt_file%
set video_root_dir=%ROOT%\data\%processed_data_name%

rem Inference parameters
set out_dir_base=%ckpt_dir%\samples
set controlnet_weights=1.0
set controlnet_guidance_start=0.0
set controlnet_guidance_end=0.8
set pool_style=avg
set /a SEED=%RANDOM% * 32768 + %RANDOM%
set out_dir=%out_dir_base%\checkpoint-%ckpt_steps%_%processed_data_name%_%SEED%
rem ====================================

if not exist "%MODEL_PATH%" (
    echo ERROR: Base model not found: %MODEL_PATH%
    echo Run: scripts\download_cogvideox.bat
    exit /b 1
)
if not exist "%ckpt_path%" (
    echo ERROR: AnchorWeave checkpoint not found: %ckpt_path%
    echo Download the AnchorWeave pretrained weights and place at: %ckpt_path%
    exit /b 1
)

set CUDA_VISIBLE_DEVICES=0
python inference/cli_demo_camera_i2v_pcd.py ^
    --video_root_dir %video_root_dir% ^
    --base_model_path %MODEL_PATH% ^
    --controlnet_model_path %ckpt_path% ^
    --output_path "%out_dir%" ^
    --start_camera_idx 0 ^
    --end_camera_idx 8 ^
    --controlnet_weights %controlnet_weights% ^
    --controlnet_guidance_start %controlnet_guidance_start% ^
    --controlnet_guidance_end %controlnet_guidance_end% ^
    --controlnet_input_channels 3 ^
    --controlnet_transformer_num_attn_heads 16 ^
    --controlnet_transformer_attention_head_dim 64 ^
    --controlnet_transformer_out_proj_dim_factor 64 ^
    --controlnet_transformer_out_proj_dim_zero_init ^
    --vae_channels 16 ^
    --num_frames 161 ^
    --num_inference_steps 5 ^
    --height 720 ^
    --width 960 ^
    --controlnet_transformer_num_layers 16 ^
    --infer_with_mask ^
    --pool_style %pool_style% ^
    --seed %SEED% ^
    --use_camera_condition ^
    --split_type test ^
    --stats_csv "%out_dir%\stats_%SEED%.csv"
