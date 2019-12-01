#!/bin/bash
# Author: Amos Chen
# Description: 简单脚本，用于下载 kubeadm 所需镜像，并修改成相应的 tag 信息

# 定义 master 节点所需镜像
MasterImageList="
k8s.gcr.io/kube-apiserver:v1.16.2
k8s.gcr.io/kube-controller-manager:v1.16.2
k8s.gcr.io/kube-scheduler:v1.16.2
k8s.gcr.io/kube-proxy:v1.16.2
k8s.gcr.io/pause:3.1
k8s.gcr.io/etcd:3.3.15-0
k8s.gcr.io/coredns:1.6.2
quay.io/coreos/flannel:v0.11.0-amd64
"

# 定义 node 节点所需镜像
NodeImageList="
k8s.gcr.io/kube-proxy:v1.16.2
k8s.gcr.io/pause:3.1
quay.io/coreos/flannel:v0.11.0-amd64
"

# 定义 dockerhub 上个人镜像仓库
PrivateReg="byteedu"

# master 节点镜像处理函数
function MasterImageProcess()
{
  for IMAGE in ${MasterImageList};
  do
    Image=$(echo ${IMAGE}|awk -F '/' {'print $NF'})
    PrivateImage=${PrivateReg}/${Image}
    docker pull ${PrivateImage}; \
    docker tag ${PrivateImage} ${IMAGE}; \
    docker rmi ${PrivateImage}
  done
}

# node 节点镜像处理函数
function NodeImageProcess()
{
  for IMAGE in ${NodeImageList};
  do
    Image=$(echo ${IMAGE}|awk -F '/' {'print $NF'})
    PrivateImage=${PrivateReg}/${Image}
    docker pull ${PrivateImage}; \
    docker tag ${PrivateImage} ${IMAGE}; \
    docker rmi ${PrivateImage}
  done
}

# 定义函数主函数

function MAIN()
{
  read -p "当前节点是作为 master 还是 node ？[master|node] " -t 30 CHOICE
  case ${CHOICE} in
  "master"|"m"|"MASTER"|"M")
    MasterImageProcess
    [ $? -eq 0 ] && echo -e "Master 节点镜像 \033[32m[处理成功]\033[0m" || (echo -e "Master 节点镜像 \033[31m[处理失败]\033[0m，请手动检查！" && exit 1)
    ;;
  "node"|"n"|"NODE"|"N")
    NodeImageProcess
    [ $? -eq 0 ] && echo -e "Node 节点镜像 \033[32m[处理成功]\033[0m" || (echo -e "Node 节点镜像 \033[31m[处理失败]\033[0m，请手动检查！" && exit 1)
    ;;
  *)
    echo "输入参数不合法，请输入 master 或者 node."
    exit
    ;;
  esac
}

MAIN
