#!/bin/bash

PROJECT_DIR="$HOME/Documents/qimai/opencode-medical"
DATA_DIR="$PROJECT_DIR/data/conversations"

echo "🔄 备份 OpenCode 聊天记录..."

# 确保目录存在
mkdir -p "$DATA_DIR"

# 复制最新会话（如果使用了自定义路径）
if [ -d "$OPENCODE_DATA_DIR/conversations" ]; then
    cp -r "$OPENCODE_DATA_DIR/conversations"/* "$DATA_DIR"/ 2>/dev/null || true
fi

# 同时备份默认位置的（以防万一）
if [ -d "$HOME/.local/share/opencode/conversations" ]; then
    cp -r "$HOME/.local/share/opencode/conversations"/* "$DATA_DIR"/ 2>/dev/null || true
fi

# Git 提交
cd "$PROJECT_DIR"
git add data/conversations/
git commit -m "chore: backup chats $(date '+%Y-%m-%d %H:%M:%S')" || echo "无变更需要提交"

# 可选：推送到远程
git push origin main

echo "✅ 备份完成: $(date)"
