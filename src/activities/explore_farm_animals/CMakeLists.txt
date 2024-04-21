#=============================================================================
# SPDX-FileCopyrightText: 2015 Djalil Mesli <djalilmesli@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RESOURCE(activities/explore_farm_animals
  QML_FILES
  *.qml
  *.js
  resource/board/*.qml
  RESOURCES
  *.svg
  resource/animals/*.webp
  resource/animals/*.svg
  resource/animals/*.${COMPRESSED_AUDIO}

)
