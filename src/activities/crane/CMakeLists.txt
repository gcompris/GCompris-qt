#=============================================================================
# SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RCC(activities/crane
  QML_FILES
  *.qml
  *.js
  resource/*/Data.qml
  RESOURCES
  *.svg
  resource/*.svg
  resource/letters/*.svg
)
