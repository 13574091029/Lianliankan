#!/bin/bash

# ---------------------------
# Flutter Web 一键更新 + 部署到 GitHub Pages
# ---------------------------

# 配置区（替换成你自己的）
GITHUB_REPO="https://github.com/13574091029/Lianliankan.git"
REPO_NAME="Lianliankan"  # 仓库名，用于 base href

# 1. 更新 main 分支代码
git checkout main
git pull origin main

# 2. 清理并构建 Web release，设置 base href
flutter clean
flutter pub get
flutter build web --release --base-href "/$REPO_NAME/"

# 3. 进入 build/web
cd build/web

# 4. 初始化 Git（如果第一次部署）
if [ ! -d ".git" ]; then
  git init
fi

# 5. 提交 Web 文件
git add .
git commit -m "Deploy Flutter Web" || echo "Nothing to commit"

# 6. 强制推送到 gh-pages 分支
git branch -M gh-pages
git remote add origin $GITHUB_REPO 2>/dev/null || true
git push -f origin gh-pages

echo "✅ Flutter Web 已部署到 GitHub Pages"
echo "访问链接: https://13574091029.github.io/Lianliankan/"