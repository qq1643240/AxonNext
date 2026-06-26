# AxonNext

> Priority Hub for iOS 14–16.5 — Next Generation

基于 [Axon](https://github.com/Baw-Appie/Axon) 二次开发，支持 iOS 14–16.5 越狱设备。

## 支持的越狱环境

| 越狱 | 支持 | 架构 |
|------|------|------|
| Dopamine Rootless | ✅ | arm64, arm64e |
| RootHide Bootstrap | ✅ | arm64, arm64e |
| palera1n Rootless | ✅ | arm64, arm64e |

## 功能特性

### 四方向手势
- **上滑**：打开应用（可自定义）
- **下滑**：清除该应用通知（可自定义）
- **左滑**：静音通知（可自定义）
- **右滑**：收藏/置顶应用（可自定义）

### 长按菜单
- 打开应用
- 查看通知
- 清除通知
- 清除全部通知
- 静音/取消静音
- 收藏/取消收藏
- 复制通知内容

### 布局自定义
- 图标大小
- 图标间距
- 每行数量
- 圆角样式
- 自动排列

### 动画效果
- Apple Spring
- Scale
- Bounce
- Fluid
- Jelly
- Fade

### 通知功能
- 长按预览
- 白名单
- 黑名单
- 排序方式（时间/数量/名称）
- 通知角标

### 外观
- 浅色
- 深色
- 跟随系统
- 毛玻璃
- 透明

### 性能优化
- UICollectionView
- 增量刷新
- 降低 CPU 占用

## 构建

项目使用 [Theos](https://theos.dev) 构建，通过 GitHub Actions 自动编译。

### 本地构建
```bash
# Rootless
make package THEOS_PACKAGE_SCHEME=rootless FINALPACKAGE=1

# Roothide
make package THEOS_PACKAGE_SCHEME=roothide FINALPACKAGE=1
```

### CI 构建
推送到 GitHub 后，Actions 会自动编译并发布：
- `AxonNext_rootless.deb`
- `AxonNext_roothide.deb`

## 项目结构
```
AxonNext/
├── .github/workflows/   # GitHub Actions CI
├── Tweak/                # Tweak 源码
├── Prefs/                # 设置面板
│   └── Resources/        # 资源文件 & 本地化
├── control               # 包信息
└── Makefile              # 构建配置
```

## 致谢
- [Axon](https://github.com/Baw-Appie/Axon) — 原作者 Nepeta & Baw Appie
- [Theos](https://theos.dev) — 越狱开发工具链
- [Cephei](https://github.com/hbang/libcephei) — 越狱开发库
- Ahmed Bousrih — 图标和横幅设计

## License
继承原仓库 License。
