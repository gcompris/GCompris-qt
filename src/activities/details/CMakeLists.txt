#=============================================================================
# SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RESOURCE(activities/details
  QML_FILES
  *.qml
  resource/*/Data.qml
  resource/board/*.qml
  RESOURCES
  *.svg
  resource/image/*.webp
)
