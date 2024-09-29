# 第一阶段：构建阶段
FROM python:3.12.6
USER root

# 设置环境变量
ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_VIRTUALENVS_CREATE=true \
    POETRY_REQUESTS_TIMEOUT=10000 \
    PATH="/root/.local/bin:$PATH" \
    PATH="/root/.cargo/bin:$PATH"

# 安装系统依赖、配置 PIP 和安装 pipx、Poetry、Rust
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg libsm6 libxext6 libgl1 curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && pip config set global.timeout 10000 \
    && pip config set global.retries 10 \
    && pip install pipx \
    && pipx ensurepath \
    && pipx install poetry==1.8.3 \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# 确保 PATH 变量已更新，安装其他 Python 包
RUN pip install nltk --default-timeout=10000 \
    && python -c "import nltk; nltk.download('punkt'); nltk.download('wordnet')"
