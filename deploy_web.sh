#!/bin/bash
# 一键部署 Flutter Web 到 GitHub Pages
# 使用前先确保 flutter 在 PATH，并且本地已配置 git

# ⚠️ 修改这里为你的仓库名
REPO_NAME="Lianliankan"
GITHUB_URL="https://github.com/13574091029/$REPO_NAME.git"

# 1️⃣ 清理旧的构建
echo "清理旧构建..."
flutter clean
flutter pub get

# 2️⃣ 构建 release Web
echo "构建 Flutter Web..."
flutter build web --release --base-href "/$REPO_NAME/"

# 3️⃣ 进入 build/web
cd build/web || exit

# 4️⃣ 初始化 git（如果第一次部署）
if [ ! -d ".git" ]; then
    git init
    git branch -M gh-pages
    git remote add origin $GITHUB_URL
fi

# 5️⃣ 提交并推送到 gh-pages
echo "推送到 gh-pages..."
git add .
git commit -m "Deploy Flutter Web $(date '+%Y-%m-%d %H:%M:%S')" -q
git push -f origin gh-pages

echo "部署完成！"
echo "访问: https://13574091029.github.io/$REPO_NAME/"