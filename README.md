# 「12ステップで作る 組込みOS自作入門」 Dockerfile

このリポジトリは「12ステップで作る 組込みOS自作入門」の開発環境を構築するための非公式の Dockerfile を提供します．これにより簡単に開発環境をセットアップして組込みOSの開発を始めることができます．

## 前提条件

- Dockerがインストールされていること
- インターネット接続が可能な環境であること

## 使い方

### セットアップ

このリポジトリをクローンします

```sh
git clone https://github.com/your_username/embedded_os_12_steps_docker.git
```

以下の構成になるように `h8write.c` を配置します．

```sh
.
├── Dockerfile
├── LICENSE
├── README.md
├── h8write.c
└── patch-gcc-3.4.6-config-h8300.txt
```

Docker Image を作成します．

```sh
docker build -t embedded_os_12_steps .
```

### フラッシュ ROM への書き込み

```sh
cd /path/to/your/workspace
docker run -it --rm -v ${PWD}:/work --device=/dev/ttyUSB0:/dev/ttyUSB0 embedded_os_12_steps /bin/bash
make write
```
