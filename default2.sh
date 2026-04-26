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
    "https://github.com/hako-mikan/sd-webui-regional-prompter"
    "https://github.com/Bing-su/adetailer"
    #"https://github.com/SignalFlagZ/sd-webui-civbrowser"
    "https://github.com/ArtVentureX/sd-webui-agent-scheduler"
    "https://github.com/thomasasfk/sd-webui-aspect-ratio-helper"
    "https://github.com/hako-mikan/sd-webui-supermerger"
    "https://github.com/DominikDoom/a1111-sd-webui-tagcomplete"
    "https://github.com/richrobber2/canvas-zoom"
    "https://github.com/alemelis/sd-webui-ar"
    #"https://github.com/Haoming02/sd-forge-couple.git"
    #"https://github.com/FallenIncursio/arcenciel-link-webui.git"
    #"https://github.com/Haoming02/sd-forge-couple.git"
)

PIP_PACKAGES=(
)

EMBEDDINGS=(
    #"https://huggingface.co/Rendai/ClondeModel/resolve/main/Smooth_Negative-neg.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/lazyneg.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/lazypos.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/SmoothNegativePony-neg.safetensors"
)

CHECKPOINT_MODELS=(
    #"https://huggingface.co/Rendai/RandeiTheWitchModel/resolve/main/Crucible/CrucibleRING.safetensors"
    #"https://huggingface.co/Rendai/RandeiTheWitchModel/resolve/main/Stellar/StellarRINGV2.1_BAKED.safetensors"
    #"https://huggingface.co/Rendai/RandeiTheWitchModel/resolve/main/Vercalion/VercalionRING_v1.safetensors"
    "https://huggingface.co/Rendai/RandeiTheWitchModel/resolve/main/Crucible/crucibleRINGSDXL_v2.8.safetensors"
    #"https://huggingface.co/circlestone-labs/Anima/resolve/main/split_files/diffusion_models/anima-preview3-base.safetensors"
    #"https://civitai.red/api/download/models/2843829?type=Model&format=SafeTensor&size=pruned&fp=bf16"
)

UNET_MODELS=(
)

LORA_MODELS=(
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/B6Crucible3/AhsokaS7PDXL_V1-Manityro-adamw.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/B6Crucible3/AhsokaTanoXL_by_KillerUwU13_AI.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/B6Crucible3/Palutena_pdxl_Incrs_v1.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/B6Crucible3/mythra-xb-richy-v1_pdxl.safetensors"
    "https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/B6Crucible3/SabineWrenXL.safetensors"
    #"https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/RitsukaTF/Fujimaru_Ritsuka_Illustrious_XL.safetensors"
    #"https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/RitsukaTF/johanna.safetensors"
    #"https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/RitsukaTF/johanna2.safetensors"
    #"https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/RitsukaTF/murasakishikibu-illu-nvwls-v1.safetensors"
    #"https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/RitsukaTF/HebiNyoubou/MrsSnake_Illu_Dwnsty.safetensors"
    #"https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/RitsukaTF/HebiNyoubou/Mrs_SnakeFate_Grand_Order.safetensors"
    #"https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/RitsukaTF/HebiNyoubou/MsSnake_Fate.safetensors"
    #"https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/RitsukaTF/HebiNyoubou/Omii_san.safetensors"
    #"https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/RitsukaTF/HebiNyoubou/Omiisan.safetensors"
    #"https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/RitsukaTF/HebiNyoubou/Omisan__Mr__Snake__FateGrand_Order.safetensors"
    #"https://huggingface.co/Rendai/ClondeModel/resolve/main/Lora/RitsukaTF/HebiNyoubou/fgo_mrs_snake.safetensors"
)

VAE_MODELS=(
    "https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors"
)

ESRGAN_MODELS=(
    "https://huggingface.co/krauzerh/animesharpx4/resolve/main/4x-AnimeSharp.pth"
    "https://huggingface.co/lokCX/4x-Ultrasharp/resolve/main/4x-UltraSharp.pth"
    #"https://huggingface.co/Shandypur/ESRGAN-4x-UltraSharp/resolve/main/4x-UltraSharp.pth"
)

CONTROLNET_MODELS=(
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
    if [[ -n $HF_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
        auth_token="$HF_TOKEN"
    elif 
        [[ -n $CIVITAI_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?civitai\.com(/|$|\?) ]]; then
        auth_token="$CIVITAI_TOKEN"
    fi
    if [[ -n $auth_token ]];then
        wget --header="Authorization: Bearer $auth_token" -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    else
        wget -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    fi
}

if [[ ! -f /.noprovisioning ]]; then
    provisioning_start
fi
