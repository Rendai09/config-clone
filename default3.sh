#!/bin/bash

# Viết bởi Học AI - Tối ưu tải đa luồng 16 connection bằng aria2c

# Tải các model mặc định khi tạo Instance
DEFAULT_MODELS=false

# Điền Token của bạn vào đây (Nếu tải file riêng tư hoặc Civitai yêu cầu login)
HF_TOKEN=""
CIVITAI_TOKEN=""

# Danh sách Model Checkpoint
CHECKPOINT_MODELS=(
    "https://civitai.com/api/download/models/294995" #Ví dụ Pony
)

# Danh sách CLIP / Text Encoder
CLIP_MODELS=(
)

# Danh sách UNET
UNET_MODELS=(
)

# Danh sách VAE
VAE_MODELS=(
    "https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors"
)

# Danh sách ControlNet
CONTROLNET_MODELS=(
)

# Danh sách LoRA
LORA_MODELS=(
)

# Danh sách ESRGAN / Upscaler
ESRGAN_MODELS=(
)

# Danh sách Embeddings / Textual Inversion
EMBEDDING_MODELS=(
)

### Đoạn code xử lý bên dưới (Đã tối ưu sang aria2c) ###

function provisioning_start() {
    # Cài đặt aria2 nếu chưa có
    if ! command -v aria2c &> /dev/null; then
        echo "Đang cài đặt aria2..."
        apt-get update -y && apt-get install -y aria2
    fi

    DISK_GB_AVAILABLE=$(($(stat -f --format="%a*%S" /workspace) / 1024 / 1024 / 1024))
    MAX_GB=$((DISK_GB_AVAILABLE - 5))

    echo "Dung lượng khả dụng: ${DISK_GB_AVAILABLE}GB (Giới hạn tải: ${MAX_GB}GB)"

    provisioning_get_models
    echo "Phân đoạn tải hoàn tất!"
}

function provisioning_get_models() {
    if [[ -n $MAX_GB ]] && [[ $MAX_GB -gt 0 ]]; then
        provisioning_download "${CHECKPOINT_MODELS[@]}" "/workspace/ComfyUI/models/checkpoints"
        provisioning_download "${CLIP_MODELS[@]}" "/workspace/ComfyUI/models/clip"
        provisioning_download "${UNET_MODELS[@]}" "/workspace/ComfyUI/models/unet"
        provisioning_download "${VAE_MODELS[@]}" "/workspace/ComfyUI/models/vae"
        provisioning_download "${CONTROLNET_MODELS[@]}" "/workspace/ComfyUI/models/controlnet"
        provisioning_download "${LORA_MODELS[@]}" "/workspace/ComfyUI/models/loras"
        provisioning_download "${ESRGAN_MODELS[@]}" "/workspace/ComfyUI/models/upscale_models"
        provisioning_download "${EMBEDDING_MODELS[@]}" "/workspace/ComfyUI/models/embeddings"
    fi
}

function provisioning_download() {
    local dir=$1
    shift
    local arr=("$@")

    mkdir -p "$dir"

    for url in "${arr[@]}"; do
        if [[ -z "$url" ]]; then continue; fi

        # Tự động đính kèm Civitai Token nếu tải từ Civitai
        if [[ "$url" == *"civitai.com"* ]] && [[ -n "$CIVITAI_TOKEN" ]] && [[ "$url" != *"?token="* ]]; then
            url="${url}?token=${CIVITAI_TOKEN}"
        fi

        echo "Đang tải (Aria2 16 luồng): $url vào $dir"
        
        # Tải bằng aria2c 16 connection song song
        aria2c -x 16 -s 16 -k 1M \
               --console-log-level=error \
               --summary-interval=0 \
               -c \
               -d "$dir" \
               "$url"
    done
}

# Chạy tiến trình
provisioning_start