#=============================================================================
# SPDX-FileCopyrightText: 2016 Divyam Madaan <divyam3897@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RESOURCE(activities/categorization
  QML_FILES
  *.qml
  *.js
  resource/1/Data.qml
  resource/2/Data.qml
  resource/3/Data.qml
  resource/board/*.qml
  RESOURCES
  *.svg
  resource/*.svg
  resource/images/*/*.svg
  resource/images/*/*.webp
)
