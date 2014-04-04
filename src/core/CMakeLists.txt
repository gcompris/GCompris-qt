
set(gcompris_SRCS
  ${gcompris_SRCS}
   ActivityInfo.cpp
   ActivityInfoTree.cpp
   ApplicationInfo.cpp
#   ApplicationSettings.cpp
   File.cpp
   main.cpp
)

set(gcompris_HEADERS
  ${gcompris_HEADERS}
   ActivityInfo.h
   ActivityInfoTree.h
   ApplicationInfo.h
#   ApplicationSettings.h
   File.h
)

set(gcompris_RCCS ${gcompris_RCCS} core.qrc CACHE STRING "resourceFile" FORCE)

qt5_wrap_cpp(gcompris_MOC ${gcompris_SRCS} ${gcompris_HEADERS})
qt5_add_resources(gcompris_RCC_SRCS ${gcompris_RCCS})
set(gcompris_RCC_SRCS ${gcompris_RCC_SRCS} )

#if (USE_KCONFIG)
#  link_directories( ${KCONFIG_LIBRARY_DIR} )
#endif (USE_KCONFIG)

set_source_files_properties(${gcompris_RCC_SRCS} PROPERTIES GENERATED ON)

if(NOT ANDROID)
  add_executable(GCompris ${gcompris_SRCS} ${gcompris_MOC} ${gcompris_RCC_SRCS})
  qt5_use_modules(GCompris Qml Quick Gui Multimedia Network XmlPatterns Svg Core)
  target_link_libraries(GCompris
    ${QT_LIBRARIES}
    #  ${KCONFIG_LIB}
    )
endif(NOT ANDROID)

if(ANDROID)
  add_library(GCompris SHARED ${gcompris_SRCS} ${gcompris_MOC} ${gcompris_RCC_SRCS})
  qt5_use_modules(GCompris Qml Quick Gui Multimedia Core Svg XmlPatterns)
  target_link_libraries(GCompris
    ${QT_LIBRARIES}
    #  ${KCONFIG_LIB}
  )
endif(ANDROID)
