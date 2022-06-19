#=============================================================================
# SPDX-FileCopyrightText: 2017 Amit Sagtani <asagtani06@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================

# For Qt5
set(CALENDAR_IMPORT "import Qt.labs.calendar 1.0")
# Qt > 6.3 ships Calendar component in QtQuick.Controls
if(Qt5Widgets_VERSION VERSION_GREATER_EQUAL "6.3.0")
  set(CALENDAR_IMPORT "")
  # For Qt 6.0, 6.1 and 6.2
elseif(Qt5Widgets_VERSION VERSION_GREATER_EQUAL "6.0")
  set(CALENDAR_IMPORT "import QtQuick.Calendar 1.0")
endif()

configure_file(Calendar.qml.cmake "${CMAKE_CURRENT_SOURCE_DIR}/Calendar.qml" @ONLY)


GCOMPRIS_ADD_RCC(activities/calendar *.qml *.svg *.js)
