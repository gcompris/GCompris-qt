#=============================================================================
# SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause
#=============================================================================
include(qt_helper)

set(GCOMPRIS_SERVER_EXECUTABLE_NAME gcompris-server)

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

set(used_qt_modules ${QT_MAJOR}::Qml ${QT_MAJOR}::Quick ${QT_MAJOR}::Gui ${QT_MAJOR}::Multimedia ${QT_MAJOR}::Core ${QT_MAJOR}::Svg ${QT_MAJOR}::Sensors ${QT_MAJOR}::QuickControls2 ${QT_MAJOR}::Charts ${QT_MAJOR}::Sql ${QT_MAJOR}::QuickDialogs2)

if(ANDROID)
  add_library(${GCOMPRIS_SERVER_EXECUTABLE_NAME} SHARED ${server_SRCS} ${server_MOC})
  set(used_qt_modules ${used_qt_modules} ${QT_MAJOR}::AndroidExtras)
elseif(CMAKE_HOST_APPLE)
  add_executable(${GCOMPRIS_SERVER_EXECUTABLE_NAME} MACOSX_BUNDLE ${server_SRCS} ${server_MOC} ${gcompris_RES})
elseif(CMAKE_HOST_WIN32)
  add_executable(${GCOMPRIS_SERVER_EXECUTABLE_NAME} WIN32 ${server_SRCS} ${server_MOC} ${gcompris_RES})
else()
  add_executable(${GCOMPRIS_SERVER_EXECUTABLE_NAME} ${server_SRCS} ${server_MOC} ${gcompris_RES})
endif()

target_link_libraries(${GCOMPRIS_SERVER_EXECUTABLE_NAME} ${used_qt_modules})
target_link_libraries(${GCOMPRIS_SERVER_EXECUTABLE_NAME} gcompris_core)

gcompris_add_rcc(server
  QML_FILES
  Main.qml
  views/*.qml
  views/*/*.qml
  activities/*.qml
  activities/*/*.qml
  components/*.qml
  charts/*.qml
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

install(TARGETS ${GCOMPRIS_SERVER_EXECUTABLE_NAME}
  ARCHIVE DESTINATION bin
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  BUNDLE DESTINATION .)

# install a startup script for linux bundle
if(BUILD_STANDALONE AND UNIX AND NOT APPLE AND NOT UBUNTUTOUCH AND NOT ANDROID )
  install(PROGRAMS ../../tools/gcompris-server.sh DESTINATION bin)
endif()
