# GitHub Actions 构建 iOS 连点器项目

## 项目结构

```
ClickerApp/
├── .github/workflows/
│   └── build-ios.yml      # GitHub Actions 构建流程
├── ClickerApp/             # Swift 源代码（已有）
│   ├── ClickerApp.swift
│   ├── Info.plist
│   ├── Models/
│   │   └── ClickerSettings.swift
│   ├── Utilities/
│   │   └── TouchSimulator.swift
│   └── Views/
│       ├── MainView.swift
│       ├── TouchPadView.swift
│       ├── GestureTapView.swift
│       └── PresetsView.swift
├── README.md
└── build.sh                # 构建脚本
```

## 步骤

### 1. 创建 GitHub 仓库

1. 打开 https://github.com/new 创建新仓库
2. 命名：`clicker-ios`（或其他名字）
3. 设为公开仓库（免费）

### 2. 上传代码

方法一：用 git 命令
```bash
cd "D:\APP\xwechat_files\wxid_11kwi97la9kt22_36c9\msg\file\2026-05\ClickerApp"
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/clicker-ios.git
git push -u origin main
```

方法二：手动上传（在 GitHub 仓库页面点击 "uploading an existing file"）

### 3. GitHub Actions 会自动开始构建

构建完成后：
1. 点击 Actions 标签
2. 点击最新的 build-ios 运行
3. 找到 `build-artifact`，下载 `ClickerApp.ipa` 文件

### 4. 安装到 iPhone

安装 `.ipa` 文件到不越狱的 iPhone：

**方法一：Esign（推荐，最简单）**
1. 下载安卓端 Esign 工具
2. 登录 Apple ID
3. 上传 `.ipa` 文件签名安装

**方法二：AltStore**
1. Mac 上安装 AltStore Server
2. iPhone 和 Mac 在同一局域网
3. 通过 AltStore 安装

**方法三：TestFlight**
- 如果有朋友有 Apple Developer 账号，可以邀请你加入 TestFlight

## 免费签名说明

免费 Apple ID 签名的 App：
- 有效期：7 天
- 需要每 7 天重新签名安装
- 最多 3 个设备
- 可以正常所有功能

## 注意事项

- GitHub Actions 中 Xcode 构建约需 10-20 分钟
- 需要 Xcode 16+ 支持 iOS 18
- 首次构建需要下载依赖，可能较慢
