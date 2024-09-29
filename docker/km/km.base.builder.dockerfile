# 第一阶段：构建阶段
FROM python:3.12.6
USER root

# 设置环境变量
ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_VIRTUALENVS_CREATE=true \
    POETRY_REQUESTS_TIMEOUT=10000 \
    PATH="/root/.local/bin:$PATH" \
    PATH="/root/.cargo/bin:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg libsm6 libxext6 libgl1 curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 设置 PIP 镜像源
RUN pip config set global.timeout 10000 \
    && pip config set global.retries 10 \

# 安装 pipx 和指定版本的 Poetry、Rust 工具链
RUN pip install pipx \
    && pipx ensurepath \
    && pipx install poetry==1.8.3 \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && source ~/.bashrc

# 下载 NLTK 数据
RUN pip install nltk --default-timeout=10000 \
    && python -c "import nltk; nltk.download('punkt_tab'); nltk.download('punkt'); nltk.download('wordnet')"