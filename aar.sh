#!/bin/sh -e

# aar输出文件夹
TARGET_DIR=""
if [ -n "$1" ]; then
  TARGET_DIR=$1
else
  read -p "设置输出文件夹(末尾不带斜杠)，按Enter键:" CHOOSE
  TARGET_DIR=$CHOOSE
fi
echo "输出文件夹：${TARGET_DIR}"

# 复制依赖(从模块到老的path模式)
go mod vendor; cp -r vendor/* $GOPATH/src/; rm -rf $GOPATH/src/pkg $GOPATH/src/modules.txt ; rm -rf vendor

# 复制源码
TEMPPATH="$GOPATH/src/lilu.red/aar"
mkdir -p $TEMPPATH
# dns包
cp -r dns $TEMPPATH

# 打包
GO111MODULE="off"
gomobile bind -v -o "${TARGET_DIR}/gomobile.aar" -target=android "${TEMPPATH}/dns"
rm -rf TEMPPATH

echo "打包完成"