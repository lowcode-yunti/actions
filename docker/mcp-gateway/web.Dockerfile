# 前端静态站点镜像（nginx）。
#
# docker-image workflow 会把构建上下文整理成：
#   .ci/web/
#   ├── nginx.conf     ← 从 docker/mcp-gateway/nginx.conf 复制
#   └── html/web/      ← frontend/web 的 dist 内容（对外挂 /web 路径）
# 然后用 `-f docker/mcp-gateway/web.Dockerfile .ci/web` 构建，不把整个仓库当上下文。
FROM nginx:1.25-alpine

ENV TZ=Asia/Shanghai

# conf.d 片段会被 nginx.conf 的 http 块 include，直接替换默认站点
COPY nginx.conf /etc/nginx/conf.d/default.conf

# dist 内容落在 /web 子目录：与 VITE_BASE_URL=/web 的资源路径一致
COPY html/web/ /usr/share/nginx/html/web/

RUN test -f /usr/share/nginx/html/web/index.html \
    || { echo "dist 里没有 index.html，前端没有构建成功" >&2; exit 1; }

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1/healthz || exit 1

CMD ["nginx", "-g", "daemon off;"]
