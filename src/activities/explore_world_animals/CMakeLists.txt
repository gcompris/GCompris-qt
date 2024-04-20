#=============================================================================
# SPDX-FileCopyrightText: 2015 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RCC(activities/explore_world_animals
  QML_FILES
  *.qml
  resource/board/*.qml
  RESOURCES
  *.svg
  resource/animals/*.webp
  resource/animals/*.svg
)
