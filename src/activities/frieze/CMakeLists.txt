#=============================================================================
# SPDX-FileCopyrightText: 2023 Bruno ANSELME <be.root@free.fr>
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RESOURCE(activities/frieze
  QML_FILES
  *.qml
  *.js
  resource/*/Data.qml
  RESOURCES
  *.svg
  resource/svg/*.svg
)
