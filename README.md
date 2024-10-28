# my_app

A new Flutter project.

## 开发环境版本信息

Flutter 3.24.2 • channel stable • https://github.com/flutter/flutter.git  
Framework • revision 4cf269e36d (8 weeks ago) • 2024-09-03 14:30:00 -0700  
Engine • revision a6bd3f1de1  
Tools • Dart 3.5.2 • DevTools 2.37.2

## Vs Code 插件版本
Flutter：v3.98.0

## 代理设置
如果你无法下载依赖，打开android/gradle.properties文件，将代理相关设置的注释取消
```bash
cd flutter_demo
vim android/gradle.properties
    ...
    systemProp.http.proxyHost=127.0.0.1
    systemProp.http.proxyPort=7890
    systemProp.https.proxyHost=127.0.0.1
    systemProp.https.proxyPort=7890
# windows终端使用
set HTTP_PROXY=http://127.0.0.1:7890
set HTTPS_PROXY=http://127.0.0.1:7890
```

## 构建apk
首先克隆项目到本地：

```bash
git clone https://github.com/hanlei153/flutter_demo.git
cd flutter_demo
flutter build apk -v
```

## 构建ipa
将项目提交至github，github Actions检测到push或pull操作main分支时，会自动进行构建