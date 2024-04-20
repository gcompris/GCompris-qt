#=============================================================================
# SPDX-FileCopyrightText: 2015 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RCC(activities/sudoku
  QML_FILES
  *.qml
  *.js
  resource/*/Data.qml
  RESOURCES
  *.svg
  resource/*.svg
)
