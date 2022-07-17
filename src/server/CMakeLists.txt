#=============================================================================
# SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause
#=============================================================================
include(qt_helper)

set(GCOMPRIS_SERVER_EXECUTABLE_NAME gcompris-server)

# this is the "old" server, need to merge with actual one
set(server_SRCS
  MessageHandler.cpp
  MessageHandler.h
  ActivityData.cpp
  ActivityData.h
  ClientData.cpp
  ClientData.h
  Database.cpp
  Database.h
  GroupData.cpp
  GroupData.h
  UserData.cpp
  UserData.h
  Server.cpp
  Server.h
  Authentication.cpp
  Authentication.h
)

# server from allon
set(server_SRCS
  serverMasterController/controllers/master-controller.cpp
  serverMasterController/controllers/master-controller.h
  serverMasterController/controllers/navigation-controller.h
  serverMasterController/controllers/command-controller.h
  serverMasterController/controllers/command-controller.cpp
  serverMasterController/controllers/database-controller.h
  serverMasterController/controllers/database-controller.cpp
  serverMasterController/controllers/network-controller.h
  serverMasterController/controllers/network-controller.cpp
  serverMasterController/models/DatabaseElement.h
  serverMasterController/models/GroupData.cpp
  serverMasterController/models/GroupData.h
  serverMasterController/models/UserData.cpp
  serverMasterController/models/UserData.h
  serverMasterController/framework/command.cpp
  serverMasterController/framework/command.h
  )

# Add files that do no need to pass through the moc processor
set(server_SRCS
  ${server_SRCS}
   main.cpp
)

list(APPEND server_SRCS ${PROTO_SRCS} ${PROTO_HDRS})

include_directories(
  ../core/  # messages
  "${CMAKE_CURRENT_BINARY_DIR}/../core"   # to find config.h
  serverMasterController/
  ${Protobuf_INCLUDE_DIRS}
)

set(used_qt_modules Qt5::Qml Qt5::Quick Qt5::Gui Qt5::Multimedia Qt5::Core Qt5::Svg Qt5::Sensors Qt5::QuickControls2 Qt5::Charts Qt5::Sql qca-qt5)

if(ANDROID)
  add_library(${GCOMPRIS_SERVER_EXECUTABLE_NAME} SHARED ${server_SRCS} ${server_MOC})
  set(used_qt_modules ${used_qt_modules} Qt5::AndroidExtras)
elseif(CMAKE_HOST_APPLE)
  add_executable(${GCOMPRIS_SERVER_EXECUTABLE_NAME} MACOSX_BUNDLE ${server_SRCS} ${server_MOC} ${gcompris_RES})
elseif(CMAKE_HOST_WIN32)
  add_executable(${GCOMPRIS_SERVER_EXECUTABLE_NAME} WIN32 ${server_SRCS} ${server_MOC} ${gcompris_RES})
else()
  add_executable(${GCOMPRIS_SERVER_EXECUTABLE_NAME} ${server_SRCS} ${server_MOC} ${gcompris_RES})
endif()

target_link_libraries(${GCOMPRIS_SERVER_EXECUTABLE_NAME} ${used_qt_modules})
target_link_libraries(${GCOMPRIS_SERVER_EXECUTABLE_NAME} protobuf::libprotobuf)

target_link_libraries(${GCOMPRIS_SERVER_EXECUTABLE_NAME} gcompris_core)

gcompris_add_rcc(server main.qml *.js views/*.qml components/*.qml resource/*)


install(TARGETS ${GCOMPRIS_SERVER_EXECUTABLE_NAME}
  ARCHIVE DESTINATION bin
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  BUNDLE DESTINATION .)

# install a startup script for linux bundle
if(UNIX AND NOT APPLE AND NOT SAILFISHOS AND NOT UBUNTUTOUCH)
  install(PROGRAMS ../../tools/gcompris-server.sh DESTINATION bin)
endif()
