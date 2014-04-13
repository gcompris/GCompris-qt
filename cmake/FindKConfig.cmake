#
# Try to find KConfig library and include path.
# Once done this will define
#
# KCONFIG_FOUND
# KCONFIG_INCLUDE_PATH
# KCONFIG_LIBRARY
# 
FIND_LIBRARY(KCONFIG_LIBRARY KF5ConfigCore
  PATHS
  /usr/lib
  /usr/local/lib
  /usr/local/lib64
  ${KCONFIG_DIR}/lib
)

IF(KCONFIG_LIBRARY)
  GET_FILENAME_COMPONENT(KCONFIG_GUESSED_INCLUDE_DIR_tmp "${KCONFIG_LIBRARY}" PATH)
  STRING(REGEX REPLACE "lib$" "include" KCONFIG_GUESSED_INCLUDE_DIR "${KCONFIG_GUESSED_INCLUDE_DIR_tmp}")
ENDIF(KCONFIG_LIBRARY)

FIND_PATH(KCONFIG_INCLUDE_DIR kconfig.h
  PATHS
  ${KCONFIG_GUESSED_INCLUDE_DIR}/KF5/KConfigCore/
  ${KCONFIG_DIR}/include/KF5/KConfigCore/
  /usr/include/KF5/KConfigCore/
  /usr/local/include/KF5/KConfigCore/
)


IF( KCONFIG_INCLUDE_DIR )
  IF( KCONFIG_LIBRARY )
    SET( KCONFIG_FOUND "YES" )
    MARK_AS_ADVANCED( KCONFIG_DIR )
    MARK_AS_ADVANCED( KCONFIG_INCLUDE_DIR )
    MARK_AS_ADVANCED( KCONFIG_LIBRARY )
  ENDIF( KCONFIG_LIBRARY )
ENDIF( KCONFIG_INCLUDE_DIR )



IF( NOT KCONFIG_FOUND )
  MESSAGE("KConfig installation was not found. Please provide KCONFIG_LIBRARY and/or KCONFIG_INCLUDE_DIR:")
  MESSAGE("  - through the GUI when working with ccmake, ")
  MESSAGE("  - as a command line argument when working with cmake e.g. ")
  MESSAGE("    cmake .. -DKCONFIG_INCLUDE_DIR:PATH=/usr/local/... ")
ENDIF( NOT KCONFIG_FOUND )
