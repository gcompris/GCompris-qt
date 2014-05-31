cmake_minimum_required(VERSION 2.8)

project(gcompris C CXX)

# Set c++11 support
include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
if(COMPILER_SUPPORTS_CXX11)
        set(my_cxx_flags "-std=c++11")
elseif(COMPILER_SUPPORTS_CXX0X)
        set(my_cxx_flags "-std=c++0x")
else()
        message(STATUS "The compiler ${CMAKE_CXX_COMPILER} has no C++11 support. Please use a different C++ compiler.")
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${my_cxx_flags}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${my_cxx_flags}")

set(GCOMPRIS_MAJOR_VERSION 0)
set(GCOMPRIS_MINOR_VERSION 10)
set(GCOMPRIS_PATCH_VERSION 0)

set(GCOMPRIS_VERSION ${GCOMPRIS_MAJOR_VERSION}.${GCOMPRIS_MINOR_VERSION})

# An integer value that represents the version of the application
# Increase it at each release
set(GCOMPRIS_VERSION_CODE ${GCOMPRIS_MINOR_VERSION})

# cmake modules setup
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/")
set(CMAKE_PREFIX_PATH "${Qt5_DIR}/lib/cmake/Qt5")

# prevent build in source directory
if("${CMAKE_BINARY_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")
    message(SEND_ERROR "Building in the source directory is not supported.")
    message(FATAL_ERROR "Please remove the created \"CMakeCache.txt\" file, the \"CMakeFiles\"
            directory and create a build directory and call \"${CMAKE_COMMAND} <path to the sources>\".")
endif("${CMAKE_BINARY_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")

set(QT_REQUIRED_VERSION 5.2.0)

find_package(Qt5 ${QT_REQUIRED_VERSION} REQUIRED
            Qml Quick Gui Multimedia Core Svg XmlPatterns LinguistTools)

#get_cmake_property(_variableNames VARIABLES)
#foreach (_variableName ${_variableNames})
#    message("${_variableName}=${${_variableName}}")
#endforeach()

# Set output directory
if(ANDROID)
  # Android .so output
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/android/libs/${ARM_TARGET}/)
  set(GCOMPRIS_TRANSLATIONS_DIR ${CMAKE_BINARY_DIR}/android/assets CACHE INTERNAL "" FORCE)
  set(GCOMPRIS_RCC_DIR ${CMAKE_BINARY_DIR}/android/assets CACHE INTERNAL "" FORCE)
  add_subdirectory(android)
else(ANDROID)
  # Desktop build
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
  if(CMAKE_HOST_APPLE)
    set(_dest_dir bin/GCompris.app/Contents/MacOS)
  else()
    set(_dest_dir bin)
  endif()
  set(GCOMPRIS_TRANSLATIONS_DIR ${CMAKE_BINARY_DIR}/${_dest_dir}/translations CACHE INTERNAL "" FORCE)
  set(GCOMPRIS_RCC_DIR ${CMAKE_BINARY_DIR}/${_dest_dir} CACHE INTERNAL "" FORCE)
endif(ANDROID)

include(cmake/rcc.cmake)

# Files to translate
file(GLOB ACTIVITY_SRCS src/core/*.qml src/core/*.js src/activities/*/*.qml
  src/activities/*/*.js src/activities/activities.txt)

# Translations handling
SET(TRANSLATIONS_FILES
  translations/gcompris_bg.ts
  translations/gcompris_br.ts
  translations/gcompris_cs.ts
  translations/gcompris_da.ts
  translations/gcompris_de.ts
  translations/gcompris_el.ts
  translations/gcompris_es.ts
  translations/gcompris_fr.ts
  translations/gcompris_gd.ts
  translations/gcompris_gl.ts
  translations/gcompris_hu.ts
  translations/gcompris_lt.ts
  translations/gcompris_lv.ts
  translations/gcompris_nl.ts
  translations/gcompris_nn.ts
  translations/gcompris_pl.ts
  translations/gcompris_pt_BR.ts
  translations/gcompris_ru.ts
  translations/gcompris_sk.ts
  translations/gcompris_sl.ts
  translations/gcompris_sr.ts
  translations/gcompris_sv.ts
  translations/gcompris_ta.ts
  translations/gcompris_th.ts
  translations/gcompris_zh_TW.ts
)

# Set the output dir for the translation files to /bin
foreach(TsSource ${TRANSLATIONS_FILES})
  set_source_files_properties(${TsSource}
  PROPERTIES OUTPUT_LOCATION ${GCOMPRIS_TRANSLATIONS_DIR})
endforeach()

# FIXME On make clean the translations/*.ts files should not be removed
qt5_create_translation(QM_FILES ${ACTIVITY_SRCS} ${TRANSLATIONS_FILES})
add_custom_target(UpdateTranslations DEPENDS ${ACTIVITY_SRCS} ${TRANSLATIONS_FILES})
add_custom_target(BuildTranslations DEPENDS ${QM_FILES})
if(CMAKE_HOST_APPLE)
  install(FILES ${QM_FILES} DESTINATION GCompris.app/Contents/MacOS/translations)
else()
  install(FILES ${QM_FILES} DESTINATION bin/translations)
endif()

add_subdirectory(src)
