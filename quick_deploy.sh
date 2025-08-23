#!/bin/bash
# 一键重新部署 Flutter Web 到 GitHub Pages
# ⚠️ 修改这里为你的仓库名
REPO_NAME="Lianliankan"
GITHUB_URL="https://github.com/13574091029/$REPO_NAME.git"

echo "=== 开始重新部署 Flutter Web ==="

# 1️⃣ 清理旧构建
flutter clean
flutter pub get

# 2️⃣ 构建 release 版本
flutter build web --release --base-href "/$REPO_NAME/"

# 3️⃣ 进入构建目录
cd build/web || exit

# 4️⃣ 初始化 git（如果没有 .git）
if [ ! -d ".git" ]; then
    git init
    git branch -M gh-pages
    git remote add origin $GITHUB_URL
fi

# 5️⃣ 提交并推送
git add .
git commit -m "Update Flutter Web $(date '+%Y-%m-%d %H:%M:%S')" -q
git push -f origin gh-pages

echo "=== 部署完成！ ==="
echo "访问: https://13574091029.github.io/$REPO_NAME/"