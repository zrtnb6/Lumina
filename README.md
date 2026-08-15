# Lumina · 流光

一款 **iOS 26 原生**的情绪日记 + 每日焦点 App，全程基于 Apple 官方 **Liquid Glass（液态玻璃）** 设计语言打造。
**无需 Mac**，整套「源码 → 云端编译 IPA → 手机侧载安装」流程都跑在 GitHub Actions 上。

> 本工程参考了桌面上一份名为 `Lumina.txt` 的**未经验证**代码建议，但仅取其「流光 / 液态玻璃情绪应用」的创意方向，
> 代码已**完全重写**：修正了原稿中 `Mood` 枚举作用域错乱、`GlassEffectContainer` 用法、缺持久化等问题，并补齐了完整工程与 CI 流水线。

---

## 功能

- **今日流光**：选择当下情绪（玻璃球），写下心情与「今日焦点」。
- **动态折射背景**：每种情绪对应一组渐变色，玻璃面板会实时折射、融合它。
- **流体形变操作区**：保存 / 分享 / 展开按钮在同一块玻璃上 morph（基于 `GlassEffectContainer` + `glassEffectID`）。
- **流光时间线**：历史记录以玻璃卡片呈现，支持滑动删除。
- **设置**：触感反馈、保持屏幕常亮、关于。
- **本地持久化**：纯 `JSON` 文件存储，零外部依赖、零后端。

## 液态玻璃技术要点（iOS 26 官方 API）

| 用法 | API |
| --- | --- |
| 给任意视图套玻璃材质 | `.glassEffect(.regular, in: RoundedRectangle(cornerRadius: 26))` |
| 可交互玻璃（有触摸反馈） | `.glassEffect(.regular.interactive(), in: Circle())` |
| 多块玻璃协同折射 / 形变 | `GlassEffectContainer { ... }` + `.glassEffectID("id", in: ns)` |
| 玻璃按钮 | `.buttonStyle(.glass)` / `.buttonStyle(.glassProminent)` |
| 底部 TabBar | 系统自动套上 Liquid Glass 浮条（无需手写） |

---

## 目录结构

```
Lumina/
├── project.yml                 # XcodeGen 工程定义（iOS 26 部署目标、无签名配置、scheme）
├── Lumina/
│   ├── LuminaApp.swift         # @main 入口
│   ├── Info.plist
│   ├── Models/                 # Mood 枚举 + 调色板、MoodEntry 模型
│   ├── Store/                  # LuminaStore（JSON 本地持久化，@Observable）
│   └── Views/                  # ContentView / TodayView / HistoryView / SettingsView / 玻璃组件
└── .github/workflows/
    └── build-ipa.yml           # 无 Mac 云端编译 unsigned IPA
```

---

## 一、本地构建（有 Mac 时）

需要 **Xcode 26**（含 iOS 26 SDK）与 [XcodeGen](https://github.com/yonaskolb/XcodeGen)：

```bash
brew install xcodegen
xcodegen generate          # 生成 Lumina.xcodeproj
open Lumina.xcodeproj
# 选你的开发团队签名后，⌘R 运行 / ⌘B 归档
```

## 二、GitHub 云编译（无 Mac 也能用）

1. 把这个仓库推到 GitHub（见下方「提交与推送」）。
2. 进入仓库 **Actions → Build IPA (no Mac needed)**，点 **Run workflow**。
3. 等待约 3–6 分钟，到 **Artifacts** 里下载 `Lumina-unsigned-ipa`（即 `Lumina.ipa`）。
4. 推送 `v1.0.0` 之类的 tag，会自动把 IPA 发到 **Releases**。

> 若 runner 自带的 Xcode 版本过低导致 iOS 26 编译失败，把 `build-ipa.yml` 里的
> `runs-on: macos-latest` 改成 `macos-26`，或在「Select Xcode」步骤手动指定 `Xcode_26.app` 路径。

## 三、把 IPA 装到 iPhone（无 Mac / 无付费开发者）

unsigned IPA 不能直接安装，需用工具**用你的免费 Apple ID 重新签名**后侧载：

- **AltStore**：手机装 AltStore → 电脑打开 AltStore，把 `Lumina.ipa` 拖进去安装（7 天需刷新）。
- **Sideloadly**：电脑跑 Sideloadly，选 `Lumina.ipa` + 你的 Apple ID，一键安装。

免费账号签名的应用每 7 天需重新签名一次；有付费开发者账号则可在 `project.yml` 填 `DEVELOPMENT_TEAM` 走正式签名。

---

## 注意事项

- **仅支持 iOS 26+ 设备**（液态玻璃是 iOS 26 引入）。
- 默认 `PRODUCT_BUNDLE_IDENTIFIER` 为 `com.lumina.Lumina`，正式发布前请改成你自己的。
- 这是一份可直接编译的工程；若某处 Apple API 后续有微调，按 Xcode 报错提示小修即可。

## 提交与推送（本地已 `git init` 并提交）

```bash
cd Lumina
git remote add origin https://github.com/<你的用户名>/Lumina.git
git push -u origin main
# 发布 Release：git tag v1.0.0 && git push --tags
```
