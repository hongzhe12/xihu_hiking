# 西湖徒步

西湖徒步路线库与离线收藏 App，Flutter 3.16 / Dart 3.2。

## 功能

- 路线首页：风景 Banner、路线搜索，以及简单/中等/困难筛选。
- 路线详情：大图封面、路线数据、介绍、特点与注意事项。
- 我的收藏：复用路线卡片，收藏状态通过 SharedPreferences 保存在本机。
- 底部导航只保留「路线」与「收藏」两个入口。

数据位于 `assets/data/routes.json`，为离线示例内容。
封面为本地打包的 Unsplash 示例风景图，来源记录见 `IMAGE_CREDITS.md`。

## 运行

```powershell
flutter pub get
flutter run
```

## 验证

```powershell
flutter analyze
flutter build web
```
