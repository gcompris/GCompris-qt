#=============================================================================
# SPDX-FileCopyrightText: 2015 Stephane Mankowski <stephane@mankowski.fr>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RESOURCE(activities/clockgame
  QML_FILES
  *.qml
  *.js
  resource/*/Data.qml
  RESOURCES
  *.svg
  resource/*.svg
)
