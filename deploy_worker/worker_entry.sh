#!/bin/bash -ex

getent passwd build || {
  groupadd -r build -g $APP_GID
  useradd -u $APP_UID -r -g build -d /home/build -m -s /bin/bash -c "Build user" build
}
[ ! -e /dev/dri/controlD64 ] || {
  VIDEO_GID=$(stat -c "%g" /dev/dri/controlD64)
  getent group video_build || groupadd -o video_build -g $VIDEO_GID
  usermod -aG video_build build
}

chown build:build /home/build

/app/deploy/worker_prepare_root.sh

exec su - build -c "cd $BASE_DIR; . /app/deploy/worker_launch.sh"
