#=============================================================================
# SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RESOURCE(activities/geo-country
  QML_FILES
  *.qml
  resource/board/*.qml
  resource/*/Data.qml
  RESOURCES
  *.svg
  resource/*/*.svgz
)
