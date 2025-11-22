#=============================================================================
# SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause
#=============================================================================
include(qt_helper)

set(GCOMPRIS_TEACHERS_EXECUTABLE_NAME gcompris-teachers)

# server
set(server_SRCS
  controllers/database-controller.h
  controllers/database-controller.cpp
  controllers/network-controller.h
  controllers/network-controller.cpp
  )

# Add files that do no need to pass through the moc processor
set(server_SRCS
  ${server_SRCS}
  main.cpp
)

include_directories(
  ../core/  # messages
  "${CMAKE_CURRENT_BINARY_DIR}/../core"   # to find config.h
  controllers/
)

# Still use QtCharts instead of QtGraphs because StackedBarSeries is not yet implemented in QtGraphs
find_package(${QT_MAJOR} ${QT_REQUIRED_VERSION} COMPONENTS Charts Widgets)
set_package_properties(${QT_MAJOR}Charts PROPERTIES TYPE REQUIRED)
set_package_properties(${QT_MAJOR}Widgets PROPERTIES TYPE REQUIRED)

set(used_qt_modules ${QT_MAJOR}::Qml ${QT_MAJOR}::Quick ${QT_MAJOR}::Gui ${QT_MAJOR}::Core ${QT_MAJOR}::Svg ${QT_MAJOR}::QuickControls2 ${QT_MAJOR}::Charts ${QT_MAJOR}::Sql)

if(ANDROID)
  add_library(${GCOMPRIS_TEACHERS_EXECUTABLE_NAME} SHARED ${server_SRCS} ${server_MOC})
  set(used_qt_modules ${used_qt_modules} ${QT_MAJOR}::AndroidExtras)
elseif(CMAKE_HOST_APPLE)
  add_executable(${GCOMPRIS_TEACHERS_EXECUTABLE_NAME} MACOSX_BUNDLE ${server_SRCS} ${server_MOC} ${gcompris_RES})
elseif(CMAKE_HOST_WIN32)
  add_executable(${GCOMPRIS_TEACHERS_EXECUTABLE_NAME} WIN32 ${server_SRCS} ${server_MOC} ${gcompris_RES})
else()
  add_executable(${GCOMPRIS_TEACHERS_EXECUTABLE_NAME} ${server_SRCS} ${server_MOC} ${gcompris_RES})
endif()

target_link_libraries(${GCOMPRIS_TEACHERS_EXECUTABLE_NAME} ${used_qt_modules})
target_link_libraries(${GCOMPRIS_TEACHERS_EXECUTABLE_NAME} OpenSSL::Crypto OpenSSL::SSL)
target_link_libraries(${GCOMPRIS_TEACHERS_EXECUTABLE_NAME} gcompris_core)

gcompris_add_rcc(server
  QML_FILES
  Main.qml
  views/*.qml
  views/*/*.qml
  activities/*.qml
  activities/*/*.qml
  components/*.qml
  dialogs/*.qml
  panels/*.qml
  singletons/*.qml
  *.js
  RESOURCES
  resource/*
  singletons/qmldir
  database/*.sql
  help/*.html
)

if(PACKAGE_SERVER)
  include(PackageServer.cmake)
endif()
