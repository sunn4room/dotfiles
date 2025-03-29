#!/bin/bash

systemctl --user enable rclone@jianguoyun.service
systemctl --user start rclone@jianguoyun.service
