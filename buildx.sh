
source /etc/profile
export |grep DOCKER_REG |grep -Ev "PASS|PW"
repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo
repoHub=docker.io
echo "${DOCKER_REGISTRY_PW_dockerhub}" |docker login --username=${DOCKER_REGISTRY_USER_dockerhub} --password-stdin $repoHub


function doBuildx(){
    local tag=$1
    local dockerfile=$2

    repo=registry-1.docker.io
    # repo=registry.cn-shenzhen.aliyuncs.com
    test ! -z "$REPO" && repo=$REPO #@gitac
    test -z "$img" && img="docker-bunsenlabs-desktop"
    img="$img:$tag"
    # cache
    ali="registry.cn-shenzhen.aliyuncs.com"
    # request to https://registry.cn-shenzhen.aliyuncs.com/v2/infrastlabs/docker-hdmi-desktop/manifests/hdmi-cache: 403 Forbidden
    # cimg="docker-hdmi-desktop-cache:$tag"
    cimg="$img-cache"
    
    plat="--platform linux/amd64,linux/arm64" #,linux/arm
    plat="--platform linux/amd64" #dbg

    compile="alpine-compile"; builddate=$(date +%Y-%m-%d_%H:%M:%S)
    # test "$plat" != "--platform linux/amd64,linux/arm64,linux/arm" && compile="${compile}-dbg"
    # --build-arg REPO=$repo/ #temp notes, just use dockerHub's
    args="""
    --provenance=false 
    --build-arg VER=$tag
    --build-arg REPO=$repo/
    --build-arg COMPILE_IMG=$compile
    --build-arg NOCACHE=$builddate
    --build-arg BUILDDATE=$builddate
    """

    # cd flux
    # test "$plat" != "--platform linux/amd64,linux/arm64,linux/arm" && img="${img}-dbg"
    # test "$plat" != "--platform linux/amd64,linux/arm64,linux/arm" && cimg="${cimg}-dbg"
    
    # ref :3000/sam/quickstart-dockerfile >> mode=max
    #  oci-mediatypes=true,image-manifest=true,:ali-403-forbidden
    
    # # 暂取消cache模式
      # export REPO_ALI=registry.cn-shenzhen.aliyuncs.com
      # export REPO_TEN=ccr.ccs.tencentyun.com
      # export REPO_TEN_HK=hkccr.ccs.tencentyun.com #/infrastlabs/repo1
      # export REPO_QING=dockerhub.qingcloud.com #无Area.zone分区
      ali2=$REPO_TEN_HK
    cache="--cache-from type=registry,ref=$ali2/$ns/$cimg"
    cache="$cache --cache-to type=registry,ref=$ali2/$ns/$cimg,mode=max"
    # request to https://registry.cn-shenzhen.aliyuncs.com/v2/infrastlabs/docker-hdmi-desktop-cache/manifests/hdmi: 403 Forbidden
    # cache="$cache --cache-to type=registry,ref=$ali/$ns/$cimg"
    
    # drop: oci-mediatypes=true,:  还是403错
    # output="--output type=image,name=$repo/$ns/$img,push=true,annotation.author=sam"
    output="--output type=image,name=$repo/$ns/$img,push=true,oci-mediatypes=true,annotation.author=sam"
    docker buildx build $cache $plat $args $output -f $dockerfile . 

}

ns=infrastlabs
ver=v51 #base-v5 base-v5-slim
case "$1" in
bunsenlabs)
    # doBuildx deian10-lithium-archives src/bunsenlabs-desktop/Dockerfile.archives
    # doBuildx deian10-lithium-repo src/bunsenlabs-desktop/Dockerfile.repo
    doBuildx deian10-lithium src/bunsenlabs-desktop/Dockerfile
    exit 0
    ;;
openbox)
    export img="docker-openbox-desktop"
    doBuildx latest src/openbox-desktop/Dockerfile
    ;;
*)
    # doBuildx $1 src/Dockerfile.$1
    echo "emp params"
    ;;          
esac