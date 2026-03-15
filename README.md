# 口算训练师 (Math Trainer)

一款面向小学生的口算练习应用，支持自由练习和闯关模式。

## 功能特点

- **自由练习**: 选择题目数量、难度和运算类型
- **闯关模式**: 10个关卡，难度逐渐递增
- **错题本**: 记录并巩固薄弱知识点
- **进度追踪**: 显示正确率和用时统计

## 支持平台

- iOS
- Android

## 快速开始

### 环境要求

- Flutter 3.x
- Dart 3.x

### 安装依赖

```bash
cd education
flutter pub get
```

### 运行项目

```bash
# 调试模式
flutter run

# 构建 iOS
flutter build ios

# 构建 Android
flutter build apk
```

## 项目结构

```
lib/
├── main.dart              # 应用入口
├── models/
│   └── problem.dart       # 题库模型
└── screens/
    ├── home_screen.dart   # 首页
    ├── practice_screen.dart   # 练习页面
    ├── challenge_screen.dart  # 闯关模式
    ├── wrong_book_screen.dart # 错题本
    └── settings_screen.dart   # 设置页面
```

## 许可证

MIT License
