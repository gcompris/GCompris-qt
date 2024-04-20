#=============================================================================
# SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RCC(activities/paintings
  QML_FILES
  *.qml
  *.js
  resource/board/*.qml
  RESOURCES
  *.svg
  resource/image/*.webp
  resource/image/*.svg
)
