
set(gcompris_SRCS
   ActivityInfo.cpp
   ActivityInfoTree.cpp
   ApplicationInfo.cpp
   ApplicationSettings.cpp
   File.cpp
)

set(gcompris_HEADERS
   ActivityInfo.h
   ActivityInfoTree.h
   ApplicationInfo.h
   ApplicationSettings.h
   File.h
)

qt5_wrap_cpp(gcompris_MOC ${gcompris_SRCS} ${gcompris_HEADERS})

# main.cpp needs not moc
set(gcompris_SRCS
   ${gcompris_SRCS}
   main.cpp
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
