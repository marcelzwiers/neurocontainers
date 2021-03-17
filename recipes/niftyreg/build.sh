# this template file builds itksnap and is then used as a docker base image for layer caching
export toolName='niftyreg'
export toolVersion='2014.14.11'
export commit_sha='83d8d1182ed4c227ce4764f1fdab3b1797eecd8d'

if [ "$1" != "" ]; then
    echo "Entering Debug mode"
    export debug="true"
fi

source ../main_setup.sh

neurodocker generate ${neurodocker_buildMode} \
   --base 'ubuntu:20.04' \
   --pkg-manager apt \
   --install apt_opts="--quiet" wget unzip cmake make g++ \
   --workdir=/opt/builder/ \
   --run="wget --no-check-certificate https://github.com/CAIsr/niftyreg/archive/${commit_sha}.zip" \
   --run="unzip ${commit_sha}.zip && rm ${commit_sha}.zip && mv niftyreg-${commit_sha} src" \
   --run="mkdir -p build install" \
   --run="cmake -S src -B build -D CMAKE_INSTALL_PREFIX=/opt/install" \
   --run="cd build && make && make install" \
   --base 'ubuntu:20.04' \
   --pkg-manager apt \
   --run="printf '#!/bin/bash\nls -la' > /usr/bin/ll" \
   --run="chmod +x /usr/bin/ll" \
   --run="mkdir ${mountPointList}" \
   --workdir=/opt/${toolName}-${toolVersion}/ \
   --copy-from '0' /opt/builder/install/ /opt/${toolName}-${toolVersion}/ \
   --env TOOLBOX_PATH=/opt/${toolName}-${toolVersion}/ \
   --env PATH=/opt/${toolName}-${toolVersion}:${PATH} \
   --env DEPLOY_PATH=/opt/${toolName}-${toolVersion}/bin/ \
   --copy README.md /README.md \
  > ${toolName}_${toolVersion}.Dockerfile

if [ "$debug" = "true" ]; then
   ./../main_build.sh
fi
