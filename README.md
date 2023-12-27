# OpenCV docker image

## 1. Docker image registry

Create the ECR repository to host the handler Docker image.

```shell
aws ecr create-repository --repository-name common/opencv-base --tags Key=application,Value=common/opencv-base
aws ecr put-lifecycle-policy --repository-name common/opencv-base --lifecycle-policy-text "file://ecr-lifecycle-policy.json"
```

### 2. Build image

```shell
make build
```

### 3. Push image

```shell
make push
```

## Usage

The build result is located in the /opencv folder.
Eg, Set OPENCV_BUILD_ROOT environment variable to /opencv for usage with @u4/opencv4node
