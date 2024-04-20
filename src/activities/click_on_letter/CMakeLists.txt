#=============================================================================
# SPDX-FileCopyrightText: 2015 Holger Kaelberer <holger.k@elberer.de>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RCC(activities/click_on_letter
  QML_FILES
  *.qml
  *.js
  RESOURCES
  *.svg
  resource/*.svg
  resource/*.json
)
