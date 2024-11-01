# 第二阶段：生产环境
FROM python:3.12.6-slim

USER root

RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg libsm6 libxext6 libgl1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*