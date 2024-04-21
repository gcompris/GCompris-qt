#=============================================================================
# SPDX-FileCopyrightText: 2016 SOURADEEP BARUA <sourad97@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RESOURCE(activities/morse_code
  QML_FILES
  *.qml
  *.js
  resource/*/Data.qml
  RESOURCES
  *.svg
  resource/*.svg
  resource/*.wav
)
