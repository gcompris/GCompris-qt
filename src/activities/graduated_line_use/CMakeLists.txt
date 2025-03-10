#=============================================================================
# SPDX-FileCopyrightText: 2023 Bruno ANSELME <be.root@free.fr>
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RESOURCE(activities/graduated_line_use
  QML_FILES
  *.qml
  resource/*/Data.qml
  RESOURCES
  *.svg
  DEPENDENCIES
  graduated_line_read
)
