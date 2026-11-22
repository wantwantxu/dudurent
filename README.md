# DuduRent · 嘟嘟租房

本地优先的房东 / 租客租房管理 Flutter App：抄表、报修、退租结算、收益明细、家具家电照片（含 360 全景浏览）、JSON 备份。

> GitHub 建议仓库名：`dudurent`

## 功能

- **房东端**：房源台账、财务收益 / 押金、新增 / 长按删除房源、自定义抄表、报修、退租结算
- **租户端**：我的小窝、账单、在线缴租、房源详情
- **系统设置**：身份开关（房东 / 租户，默认可全开）、数据导出导入 / 重置演示数据
- **本地持久化**：SharedPreferences（JSON）+ 应用私有目录存照片

## 快速开始

```bash
flutter pub get
flutter run
flutter test
```

真机（arm64）安装包：

```bash
flutter build apk --release --target-platform android-arm64
```

上架说明见 [docs/STORE_RELEASE.md](docs/STORE_RELEASE.md)。

## 隐私与配置

本仓库不包含：

- `android/local.properties`（本机 Flutter / SDK 路径）
- `android/key.properties`、`*.jks` / `*.keystore`（正式签名）
- 构建产物 `build/`、`*.apk` / `*.aab`

发布签名请复制 `android/key.properties.example` 为本地 `key.properties`，勿提交到 Git。

## License

[MIT](LICENSE)
