#=============================================================================
# SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RCC(activities/geography
  QML_FILES
  *.qml
  resource/board/*.qml
  RESOURCES
  *.svg
  resource/*/*.svgz
)
