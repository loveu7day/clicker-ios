# ClickerApp - iOS 连点器

## 项目说明

这是一个基于 SwiftUI 的 iOS 连点器应用。

## 功能特性

- **持续点击模式**：无限循环点击指定位置
- **次数点击模式**：点击指定次数后自动停止
- **频率控制**：50ms - 5000ms 可调
- **坐标随机偏移**：避免被识别为机器人
- **随机间隔**：更自然的点击节奏
- **触摸反馈**：可选 Haptic 触觉反馈
- **预设管理**：保存常用配置
- **手势录制**：自定义滑动路线

## 快速开始

### 1. 在 Mac 上打开项目

```bash
# 将 ClickerApp 文件夹复制到 Mac 上
# 然后用 Xcode 打开
```

### 2. 创建 Xcode 项目

由于这是一个纯 SwiftUI 代码项目，你需要：

1. 打开 Xcode
2. File -> New -> Project
3. 选择 iOS -> App
4. 项目名称：ClickerApp
5. 将本项目中的 `ClickerApp` 文件夹内容替换生成的 `Views/Models/Utilities/` 等文件夹

### 3. 直接在手机上使用（无需电脑）

更简单的方式：使用 **快捷指令** 实现类似功能：

1. 打开「快捷指令」App
2. 新建快捷指令
3. 添加动作「启动屏幕点击」
4. 设置坐标和间隔

## 文件结构

```
ClickerApp/
├── ClickerApp.swift           # App 入口
├── Info.plist                  # 应用配置
├── Models/
│   └── ClickerSettings.swift   # 数据模型
├── ViewModels/
├── Views/
│   ├── MainView.swift          # 主界面
│   ├── TouchPadView.swift      # 触控板
│   ├── GestureTapView.swift    # 手势点击
│   └── PresetsView.swift       # 预设管理
└── Utilities/
    └── TouchSimulator.swift    # 核心引擎
```

## 注意事项

- 此连点器在应用内生效，无法直接点击其他 App
- 需要 iOS 16.0+（运行在 iOS 26）
- 需要 Apple Developer 账号才能在真机上运行

## 依赖

- iOS 16.0+
- Swift 5.7+
- Xcode 15+
