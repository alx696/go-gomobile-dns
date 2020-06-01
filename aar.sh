#!/bin/sh -e

# 包名
PACKAGE_NAME=""
if [ -n "$1" ]; then
  PACKAGE_NAME=$1
else
  read -p "设置包名，按Enter键:" CHOOSE
  PACKAGE_NAME=$CHOOSE
fi
echo "包名：${PACKAGE_NAME}"

# aar输出文件夹
TARGET_DIR=""
if [ -n "$2" ]; then
  TARGET_DIR=$2
else
  read -p "设置输出文件夹(末尾不带斜杠)，按Enter键:" CHOOSE
  TARGET_DIR=$CHOOSE
fi
echo "输出文件夹：${TARGET_DIR}"

# 复制依赖(从模块到老的path模式)
go mod vendor
cp -r vendor/* $GOPATH/src/
rm -rf $GOPATH/src/pkg $GOPATH/src/modules.txt
rm -rf vendor

# 复制源码
TEMPPATH="$GOPATH/src/lilu.red/aar"
mkdir -p $TEMPPATH
cp -r $PACKAGE_NAME $TEMPPATH

# 打包
GO111MODULE="off"
gomobile bind -v -o "${TARGET_DIR}/gomobile.aar" -target=android "${TEMPPATH}/$PACKAGE_NAME"
rm -rf TEMPPATH

echo "打包完成"

###
## 经常出现 golang.org/x/sys/unix 报错问题, 解决方法为删掉GOPATH中除自己的库外的其它库, 然后重新安装gomobile.
###