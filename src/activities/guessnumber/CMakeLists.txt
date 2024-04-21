#=============================================================================
# SPDX-FileCopyrightText: 2015 Thib ROMAIN <thibrom@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RESOURCE(activities/guessnumber
  QML_FILES
  *.qml
  *.js
  resource/*/Data.qml
  RESOURCES
  *.svg
  resource/*.svg
  resource/*.wav
)
