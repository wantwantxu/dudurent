# DuduRent · 上架商店指南

- 应用包名：`com.dudurent.app`
- 显示名称：嘟嘟租房
- 版本：`pubspec.yaml` 中的 `version`（如 `1.0.0+1`）

## Android

1. 安装 Android Studio，配置 SDK。
2. 生成本地签名（勿提交到 Git）：

```bash
mkdir -p android/keystore
keytool -genkey -v -keystore android/keystore/dudurent-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias dudurent
```

3. 复制 `android/key.properties.example` → `android/key.properties`，填写本地密码与路径。
4. 在 `android/app/build.gradle.kts` 中启用 `signingConfigs.release`。
5. 构建：

```bash
flutter build appbundle --release
```

## iOS

需 macOS + Xcode：

```bash
flutter build ipa --release
```

在 App Store Connect 填写相机、相册、电话等用途说明（已在 `Info.plist` 声明）。
