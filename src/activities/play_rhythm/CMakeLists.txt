#=============================================================================
# SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RCC(activities/play_rhythm
  QML_FILES
  *.qml
  *.js
  RESOURCES
  *.svg
  resource/*.svg
  resource/*.json
  resource/*.wav
)
