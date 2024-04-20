#=============================================================================
# SPDX-FileCopyrightText: 2015 Siddhesh Suthar <siddhesh.it@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RCC(activities/lang
  QML_FILES
  *.qml
  *.js
  RESOURCES
  *.svg
  resource/*.json
  resource/words_sample/*.webp
)
