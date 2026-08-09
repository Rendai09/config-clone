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
    #"https://github.com/hako-mikan/sd-webui-supermerger"
    "https://github.com/DominikDoom/a1111-sd-webui-tagcomplete"
    #"https://github.com/richrobber2/canvas-zoom"
    #"https://github.com/alemelis/sd-webui-ar"
    "https://github.com/Haoming02/sd-forge-couple"
)

PIP_PACKAGES=(
)

EMBEDDINGS=(
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/Smooth_Negative-neg.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/lazyneg.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/lazypos.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/SmoothNegativePony-neg.safetensors"
)

CHECKPOINT_MODELS=(
    #"https://huggingface.co/circlestone-labs/Anima/resolve/main/split_files/diffusion_models/anima-base-v1.0.safetensors"
    #"https://huggingface.co/FallenIncursio/Animice_and_Doe/resolve/main/Animice_and_Doe_v1.safetensors"
    #"https://huggingface.co/FallenIncursio/Skirkscendance/resolve/main/Skirkscendance_v1.safetensors"
    #"https://huggingface.co/Manityro/Vermilion-Anima/resolve/main/Vermilion-0.1-AnimaV1.safetensors"
    #"https://huggingface.co/Manityro/Hoseki_LustrousMix_AnimaBaseV1_v1/resolve/main/Hoseki_LustrousMix_animaBaseV1_v1.safetensors"
    "https://huggingface.co/Rendai/RandeiTheWitchModel/resolve/main/VercalionRING_v1.safetensors"
    "https://huggingface.co/Rendai/RandeiTheWitchModel/resolve/main/StellarRINGV2.1_BAKED.safetensors"
    "https://huggingface.co/Rendai/RandeiTheWitchModel/resolve/main/ANIMAHolice_v08.safetensors"
)

UNET_MODELS=(
)

LORA_MODELS=(
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/B12/RoseQuartzIllustrious1.0JLFO.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/B12/dcsorceress-illu-nvwls-v1.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/B12/recluse-er-richy-v1_ixl.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/B12/whitedillust.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/BIG3/naofumi_iwatani_ilxl.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/BIG3/issei%20v2.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/BIG3/kirito.safetensors"
)

VAE_MODELS=(
    "https://huggingface.co/circlestone-labs/Anima/resolve/main/split_files/vae/qwen_image_vae.safetensors"
    "https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors"
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
### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    provisioning_print_header
    provisioning_get_apt_packages
    provisioning_get_extensions
    provisioning_get_pip_packages
    
    # Bổ sung các hàm gọi tải đầy đủ mọi loại model
    provisioning_get_files "${A1111_DIR}/models/Stable-diffusion" "${CHECKPOINT_MODELS[@]}"
    provisioning_get_files "${A1111_DIR}/models/Lora" "${LORA_MODELS[@]}"
    provisioning_get_files "${A1111_DIR}/models/VAE" "${VAE_MODELS[@]}"
    provisioning_get_files "${A1111_DIR}/models/ESRGAN" "${ESRGAN_MODELS[@]}"
    provisioning_get_files "${A1111_DIR}/models/ControlNet" "${CONTROLNET_MODELS[@]}"
    provisioning_get_files "${A1111_DIR}/embeddings" "${EMBEDDINGS[@]}"
    provisioning_get_files "${A1111_DIR}/models/text_encoder" "${TEXT_ENCODER_MODELS[@]}"
    provisioning_get_files "${A1111_DIR}" "${CONFIG_AND_STYLES[@]}"

    # Avoid git errors because we run as root but files are owned by 'user'
    export GIT_CONFIG_GLOBAL=/tmp/temporary-git-config
    git config --file $GIT_CONFIG_GLOBAL --add safe.directory '*'

    # Start and exit because webui will probably require a restart
    cd "${A1111_DIR}"
    LD_PRELOAD=libtcmalloc_minimal.so.4 \
        python launch.py \
            --skip-python-version-check \
            --no-download-sd-model \
            --do-not-download-clip \
            --no-half \
            --port 17860 \
            --exit

    provisioning_print_end
}

function provisioning_get_apt_packages() {
    if [[ -n $APT_PACKAGES ]]; then
            sudo $APT_INSTALL ${APT_PACKAGES[@]}
    fi
}

function provisioning_get_pip_packages() {
    if [[ -n $PIP_PACKAGES ]]; then
            pip install --no-cache-dir ${PIP_PACKAGES[@]}
    fi
}

function provisioning_get_extensions() {
    for repo in "${EXTENSIONS[@]}"; do
        dir="${repo##*/}"
        path="${A1111_DIR}/extensions/${dir}"
        if [[ ! -d $path ]]; then
            printf "Downloading extension: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
        fi
    done
}

function provisioning_get_files() {
    if [[ -z $2 ]]; then return 1; fi
    
    dir="$1"
    mkdir -p "$dir"
    shift
    arr=("$@")
    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    for url in "${arr[@]}"; do
        printf "Downloading: %s\n" "${url}"
        provisioning_download "${url}" "${dir}"
        printf "\n"
    done
}

function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
}

function provisioning_print_end() {
    printf "\nProvisioning complete:  Application will start now\n\n"
}

function provisioning_has_valid_hf_token() {
    [[ -n "$HF_TOKEN" ]] || return 1
    url="https://huggingface.co/api/whoami-v2"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json")

    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

function provisioning_has_valid_civitai_token() {
    [[ -n "$CIVITAI_TOKEN" ]] || return 1
    url="https://civitai.com/api/v1/models?hidden=1&limit=1"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $CIVITAI_TOKEN" \
        -H "Content-Type: application/json")

    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

function provisioning_download() {
    if ! command -v aria2c &> /dev/null; then
        apt-get update -y && apt-get install -y aria2
    fi

    if [[ -z "$1" ]]; then return 0; fi
    
    url="$1"
    dir="$2"
    
    mkdir -p "$dir"
    
    if [[ "$url" == *"civitai.com"* ]] && [[ -n "$CIVITAI_TOKEN" ]] && [[ "$url" != *"?token="* ]]; then
        if [[ "$url" == *"?"* ]]; then
            url="${url}&token=${CIVITAI_TOKEN}"
        else
            url="${url}?token=${CIVITAI_TOKEN}"
        fi
    fi

    local auth_header=""
    if [[ "$url" == *"huggingface.co"* ]] && [[ -n "$HF_TOKEN" ]]; then
        auth_header="--header=Authorization: Bearer ${HF_TOKEN}"
    fi

    # Lấy tên file thật từ URL gốc (phần sau /resolve/main/)
    local filename
    filename=$(basename "$url" | sed 's/?.*$//')

    local user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

    echo "Đang tải: $url -> $dir/$filename"
    aria2c -x 8 -s 8 -k 1M \
           --user-agent="$user_agent" \
           --content-disposition=false \
           --out="$filename" \
           --auto-file-renaming=false \
           --allow-overwrite=true \
           --console-log-level=error \
           --summary-interval=0 \
           -c \
           $auth_header \
           -d "$dir" \
           "$url"
}

if [[ ! -f /.noprovisioning ]]; then
    provisioning_start
fi
