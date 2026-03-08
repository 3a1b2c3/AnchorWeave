"""Download CogVideoX-5b-I2V from HuggingFace to pretrained/CogVideoX-5b-I2V."""

from pathlib import Path
from huggingface_hub import snapshot_download

REPO_ID = "zai-org/CogVideoX-5b-I2V"
LOCAL_DIR = Path(__file__).parent.parent / "pretrained" / "CogVideoX-5b-I2V"

print(f"Downloading {REPO_ID} → {LOCAL_DIR}")
snapshot_download(repo_id=REPO_ID, local_dir=str(LOCAL_DIR))
print(f"\nDone. Model saved to: {LOCAL_DIR}")
