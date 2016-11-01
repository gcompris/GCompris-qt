if(NOT QML_BOX2D_MODULE STREQUAL disabled)
  GCOMPRIS_ADD_RCC(activities/balancebox *.qml *.svg *.js resource/* editor/*)
endif()
