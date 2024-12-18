DOCKER_DIR="./docker"
DOCKER_IMAGE_NAME="kkk2099/kkk:envoy-wasm-plugin-example-1.0"

# 找到Docker镜像的imageId
IMAGE_ID=$(docker images -q "$DOCKER_IMAGE_NAME")

# 删除旧的Docker镜像
if [ -n "$IMAGE_ID" ]; then
    echo "正在删除旧的Docker镜像..."
    docker rmi "$IMAGE_ID"
    # 检查镜像删除是否成功
    if [ $? -ne 0 ]; then
        echo "删除旧的Docker镜像失败，脚本终止。"
        exit 1
    fi
else
    echo "未找到旧的Docker镜像。"
fi

# 进入Docker目录
cd "$DOCKER_DIR"

echo "正在构建新的Docker镜像..."
docker build -t "$DOCKER_IMAGE_NAME" .

# 检查Docker构建是否成功
if [ $? -ne 0 ]; then
    echo "Docker镜像构建失败。"
    exit 1
fi

echo "Docker镜像构建成功: $DOCKER_IMAGE_NAME"

# 询问是否要推送到DockerHub
read -p "是否要推送镜像到DockerHub？(y/n): " PUSH_CHOICE

if [ "$PUSH_CHOICE" = "y" ] || [ "$PUSH_CHOICE" = "Y" ]; then
    echo "正在推送镜像到DockerHub..."
    docker push "$DOCKER_IMAGE_NAME"

    # 检查推送是否成功
    if [ $? -ne 0 ]; then
        echo "推送到DockerHub失败。"
        exit 1
    else
        echo "推送到DockerHub成功。"
    fi
else
    echo "跳过推送到DockerHub。"
fi

echo "脚本执行完成。"

