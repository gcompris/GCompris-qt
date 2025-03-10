#=============================================================================
# SPDX-FileCopyrightText: 2015 Manuel Tondeur <manueltondeur@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RESOURCE(activities/gnumch-inequality
  QML_FILES
  *.qml
  resource/*/Data.qml
  RESOURCES
  *.svg
  DEPENDENCIES
  gnumch-equality
)
