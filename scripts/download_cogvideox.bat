@echo off
setlocal

:: Destination matches MODEL_PATH in train_with_latent.bat
set REPO_ID=zai-org/CogVideoX-5b-I2V
set LOCAL_DIR=%~dp0..\pretrained\CogVideoX-5b-I2V

echo Downloading %REPO_ID% to %LOCAL_DIR% ...

huggingface-cli download %REPO_ID% --local-dir "%LOCAL_DIR%" --repo-type model

if %ERRORLEVEL% neq 0 (
    echo.
    echo huggingface-cli failed. Trying via Python ...
    python -c "from huggingface_hub import snapshot_download; snapshot_download(repo_id='%REPO_ID%', local_dir=r'%LOCAL_DIR%')"
)

echo.
echo Done. Model saved to: %LOCAL_DIR%
exit /b %ERRORLEVEL%
