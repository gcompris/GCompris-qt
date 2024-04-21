#=============================================================================
# SPDX-FileCopyrightText: 2015 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RESOURCE(activities/explore_world_music
  QML_FILES
  *.qml
  resource/board/*.qml
  RESOURCES
  *.svg
  resource/music/*.${COMPRESSED_AUDIO}
  resource/music/*.webp
  resource/music/*.svg
)
