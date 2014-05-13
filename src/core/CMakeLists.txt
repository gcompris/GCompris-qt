
configure_file(config.h.in "${CMAKE_CURRENT_BINARY_DIR}/config.h" @ONLY)

set(gcompris_SRCS
   ActivityInfo.cpp
   ActivityInfo.h
   ActivityInfoTree.cpp
   ActivityInfoTree.h
   ApplicationInfo.cpp
   ApplicationInfo.h
   ApplicationSettings.cpp
   ApplicationSettings.h
   File.cpp
   File.h
)

qt5_wrap_cpp(gcompris_MOC ${gcompris_SRCS})

# Add files that do no need to pass through the moc processor
set(gcompris_SRCS
   ${gcompris_SRCS}
   main.cpp
   config.h.in
)

include_directories(
  "${CMAKE_CURRENT_BINARY_DIR}"   # to find config.h
)

if(NOT ANDROID)
  add_executable(GCompris ${gcompris_SRCS} ${gcompris_MOC})
  qt5_use_modules(GCompris Qml Quick Gui Multimedia Network XmlPatterns Svg Core)
  target_link_libraries(GCompris
    ${QT_LIBRARIES}
    )
endif(NOT ANDROID)

if(ANDROID)
  add_library(GCompris SHARED ${gcompris_SRCS} ${gcompris_MOC})
  qt5_use_modules(GCompris Qml Quick Gui Multimedia Core Svg XmlPatterns)
  target_link_libraries(GCompris
    ${QT_LIBRARIES}
  )
endif(ANDROID)

GCOMPRIS_ADD_RCC(core)
