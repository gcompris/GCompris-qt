#=============================================================================
# SPDX-FileCopyrightText: 2023 Bruno ANSELME <be.root@free.fr>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RCC(activities/grammar_analysis
  QML_FILES
  *.qml
  *.js
  RESOURCES
  *.svg
  resource/*.json
  resource/svg/*.svg
)
