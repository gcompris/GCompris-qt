#=============================================================================
# SPDX-FileCopyrightText: 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RCC(activities/tangram
  QML_FILES
  *.qml
  dataset.js
  tangram.js
  RESOURCES
  *.svg
  resource/m-tangram/*.svg
  resource/tangram/*.svg
)
