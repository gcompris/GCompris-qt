#=============================================================================
# SPDX-FileCopyrightText: 2023 Bruno ANSELME <be.root@free.fr>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RESOURCE(activities/grammar_classes
  QML_FILES
  *.qml
  RESOURCES
  *.svg
  resource/*.json
  DEPENDENCIES
  grammar_analysis
)
