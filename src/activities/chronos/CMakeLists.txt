#=============================================================================
# SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RCC(activities/chronos
  QML_FILES
  *.qml
  *.js
  resource/1/Data.qml
  resource/2/Data.qml
  resource/board/*.qml
  RESOURCES
  *.svg
  resource/*.svg
  resource/images/*.svg
)
