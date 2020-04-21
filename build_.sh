#!/usr/bin/env bash
set -e

export imageName='name_0p0p0'

source main_setup.sh

neurodocker generate ${neurodocker_buildMode} \
   --base debian:stretch \
   --pkg-manager apt \
   --run="printf '#!/bin/bash\nls -la' > /usr/bin/ll" \
   --run="chmod +x /usr/bin/ll" \
   --run="mkdir ${mountPointList}" \
   --xxx version=xxx \
   --env DEPLOY_PATH=/opt/xxx/bin/ \
   --user=neuro \
  > recipe.${imageName}

./main_build.sh