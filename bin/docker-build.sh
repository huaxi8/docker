#!/bin/bash
# 定义镜像版本
read -p "please input images version,default[1.0.1]:" version
if [[ -z "${version}" ]]; then
	version=1.0.1
fi
# PHP版本
read -p "please input php version,Separated by spaces,default[56 70 71 72 73]:" phpVersion
if [[ -z "${phpVersion}" ]]; then
	phpVersion="56 70 71 72 73"
fi
# 默认hub name
read -p "please input hub name,default[huaxi8]:" hubName
if [[ -z "${hubName}" ]]; then
	hubName=huaxi8
fi
# Dockerfile文件目录
dockerFilePath=${HOME}/docker/docker-files/web-nginx-php
# 定义yml文件路径
ymlFile=${HOME}/docker/php-laravel/docker-compose.yml
# 获取系统版本
system=$(uname)
build_docker()
{
    for ver in ${phpVersion}
    do
        cd ${dockerFilePath}${ver}
#         编译docker镜像
        docker build -t php${ver}:${version} .
#         将新版本号写入docker-compose.yml文件
        if [[ ${system} -eq "Darwin" ]]; then
            sed -i '' "s#image: ${hubName}/php${ver}:.*#image: ${hubName}/php${ver}:${version}#g" ${ymlFile}
        else
            sed -i "s#image: ${hubName}/php${ver}:.*#image: ${hubName}/php${ver}:${version}#g" ${ymlFile}
        fi
        if [[ ${num} == y ]]; then
            docker tag php${ver}:${version} ${hubName}/php${ver}:${version}
            # push到自己的仓库
            docker push ${hubName}/php${ver}:${version}
        fi
    done
}
read -p "Do you log in to docker and push yourself to your docker hub? Confirm please input[y|n],default[n]:" num
if [[ -z "${num}" ]]; then
	num=n
fi
if [[ ${num} == y ]]; then
    # 登录docker
    docker login
fi
build_docker

