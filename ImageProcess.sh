#!/bin/bash
# Author: Amos Chen
# Description: 简单脚本，用于下载 kubeadm 所需镜像，并修改成相应的 tag 信息
ImageList="
k8s.gcr.io/kube-apiserver:v1.16.2
k8s.gcr.io/kube-controller-manager:v1.16.2
k8s.gcr.io/kube-scheduler:v1.16.2
k8s.gcr.io/kube-proxy:v1.16.2
k8s.gcr.io/pause:3.1
k8s.gcr.io/etcd:3.3.15-0
k8s.gcr.io/coredns:1.6.2
"
PrivateReg="byteedu"

for IMAGE in ${ImageList};
do
  Image=$(echo ${IMAGE}|awk -F '/' {'print $2'})
  PrivateImage=${PrivateReg}/${Image}
  docker pull ${PrivateImage}; \
  docker tag ${PrivateImage} ${IMAGE}; \
  docker rmi ${PrivateImage}
done
