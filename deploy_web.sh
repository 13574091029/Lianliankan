#!/bin/bash

# ---------------------------
# Flutter Web 一键推送到 GitHub + 部署 Web
# ---------------------------

# 配置国内镜像加速（可选）
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# 项目远程仓库地址（替换成你自己的）
GITHUB_REPO="https://github.com/13574091029/Lianliankan.git"

# 1. 初始化本地 Git（如果已经初始化，可跳过）
if [ ! -d ".git" ]; then
  git init
  git remote add origin $GITHUB_REPO
fi

# 2. 提交 Flutter 项目代码
git add .
git commit -m "Update Flutter project" || echo "Nothing to commit"
git branch -M main
git push -u origin main

# 3. 构建 Web release
flutter clean
flutter pub get
flutter build web --release

# 4. 进入 build/web 推送到 gh-pages 分支
cd build/web

git init
git add .
git commit -m "Deploy Flutter Web"
git branch -M gh-pages
git remote add origin $GITHUB_REPO || true
git push -f origin gh-pages

echo "✅ Flutter Web 已部署到 GitHub Pages"
echo "访问链接: https://13574091029.github.io/Lianliankan/"