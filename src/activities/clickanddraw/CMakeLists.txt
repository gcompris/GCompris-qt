#=============================================================================
# SPDX-FileCopyrightText: 2015 Emmanuel Charruau <echarruau@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RESOURCE(activities/clickanddraw
  QML_FILES
  *.qml
  *.js
  RESOURCES
  *.svg
  DEPENDENCIES
  number_sequence
)
