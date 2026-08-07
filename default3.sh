#!/bin/bash

source /venv/main/bin/activate
# Đổi đường dẫn thư mục gốc sang Forge
A1111_DIR=${WORKSPACE}/stable-diffusion-webui-forge

# Packages are installed after nodes so we can fix them...

APT_PACKAGES=(
    #"package-1"
    #"package-2"
)
# Thêm phần này để chứa link các file config/styles
CONFIG_AND_STYLES=(
    "https://huggingface.co/datasets/Rendai/CloneData/resolve/main/config/styles.csv"
    "https://huggingface.co/datasets/Rendai/CloneData/resolve/main/config/config.json"
    "https://huggingface.co/datasets/Rendai/CloneData/resolve/main/config/ui-config.json"
)
EXTENSIONS=(
    "https://github.com/zanllp/sd-webui-infinite-image-browsing"
    #"https://github.com/hako-mikan/sd-webui-regional-prompter"
    "https://github.com/Haoming02/ADetailer-Neo"
    #"https://github.com/SignalFlagZ/sd-webui-civbrowser"
    "https://github.com/cataclisma/sd-webui-agent-scheduler-neo"
    #"https://github.com/thomasasfk/sd-webui-aspect-ratio-helper"
    "https://github.com/hako-mikan/sd-webui-supermerger"
    "https://github.com/DominikDoom/a1111-sd-webui-tagcomplete"
    #"https://github.com/richrobber2/canvas-zoom"
    #"https://github.com/alemelis/sd-webui-ar"
    "https://github.com/Haoming02/sd-forge-couple"
)

PIP_PACKAGES=(
)

EMBEDDINGS=(
    #"https://huggingface.co/Rendai/ClondeModel/resolve/main/Smooth_Negative-neg.safetensors"
    #"https://huggingface.co/Rendai/ClondeModel/resolve/main/lazyneg.safetensors"
    #"https://huggingface.co/Rendai/ClondeModel/resolve/main/lazypos.safetensors"
    #"https://huggingface.co/Rendai/ClondeModel/resolve/main/SmoothNegativePony-neg.safetensors"
)

CHECKPOINT_MODELS=(
    #"https://huggingface.co/circlestone-labs/Anima/resolve/main/split_files/diffusion_models/anima-base-v1.0.safetensors"
    #"https://huggingface.co/FallenIncursio/Animice_and_Doe/resolve/main/Animice_and_Doe_v1.safetensors"
    #"https://huggingface.co/FallenIncursio/Skirkscendance/resolve/main/Skirkscendance_v1.safetensors"
    #"https://huggingface.co/Manityro/Vermilion-Anima/resolve/main/Vermilion-0.1-AnimaV1.safetensors"
    #"https://huggingface.co/Manityro/Hoseki_LustrousMix_AnimaBaseV1_v1/resolve/main/Hoseki_LustrousMix_animaBaseV1_v1.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/sweetBapsRimixStylized_animaV10.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/milfSoup_v2Anima.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/oneObsessionAnima_v30.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/oneObsessionBranch_matureAnimaV1.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/rdbtAnime_v2Base.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/Holiskice3.safetensors"
)

UNET_MODELS=(
)

LORA_MODELS=(
)

VAE_MODELS=(
    "https://huggingface.co/circlestone-labs/Anima/resolve/main/split_files/vae/qwen_image_vae.safetensors"
)

ESRGAN_MODELS=(
    "https://huggingface.co/krauzerh/animesharpx4/resolve/main/4x-AnimeSharp.pth"
    "https://huggingface.co/lokCX/4x-Ultrasharp/resolve/main/4x-UltraSharp.pth"
)

CONTROLNET_MODELS=(
)

TEXT_ENCODER_MODELS=(
    "https://huggingface.co/circlestone-labs/Anima/resolve/main/split_files/text_encoders/qwen_3_06b_base.safetensors"
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
        provisioning_get_files "${A1111_DIR}/models/Stable-diffusion" "${CHECKPOINT_MODELS[@]}"
        provisioning_get_files "${A1111_DIR}/models/Lora" "${LORA_MODELS[@]}"
        provisioning_get_files "${A1111_DIR}/models/VAE" "${VAE_MODELS[@]}"
        provisioning_get_files "${A1111_DIR}/models/ESRGAN" "${ESRGAN_MODELS[@]}"
        provisioning_get_files "${A1111_DIR}/models/ControlNet" "${CONTROLNET_MODELS[@]}"
        provisioning_get_files "${A1111_DIR}/embeddings" "${EMBEDDINGS[@]}"
        provisioning_get_files "${A1111_DIR}/models/text_encoder" "${TEXT_ENCODER_MODELS[@]}"
        provisioning_get_files "${A1111_DIR}" "${CONFIG_AND_STYLES[@]}"
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
