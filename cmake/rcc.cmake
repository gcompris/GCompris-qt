
function(GCOMPRIS_ADD_RCC activity)

  # Create this QRC file
  # (cannot create it in the build dir because rcc expect local files)
  set(CREATED_QRC "${CMAKE_CURRENT_SOURCE_DIR}/${activity}.qrc")

  # With these files in it
  file(GLOB QRC_CONTENTS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.qml *.svg *.js resource/*)
  file(GLOB QRC_CONTENTS_ABS ${CMAKE_CURRENT_SOURCE_DIR} *.qml *.svg *.js resource/*)

  file(WRITE ${CREATED_QRC} "<RCC>\n\t<qresource prefix=\"/gcompris/src/activities/${activity}\">")
  foreach(FILE ${QRC_CONTENTS})
      file(APPEND ${CREATED_QRC} "\n\t\t<file>${FILE}</file>")
  endforeach()
  file(APPEND ${CREATED_QRC} "\n\t</qresource>\n</RCC>\n")
  list(APPEND QRC_FILES ${CREATED_QRC})

  set(CREATED_RCC ${GCOMPRIS_RCC_DIR}/${activity}.rcc)

  add_custom_command(OUTPUT ${CREATED_RCC}
                     COMMAND ${Qt5Core_RCC_EXECUTABLE} "-binary" -o ${CREATED_RCC} ${CREATED_QRC}
                     DEPENDS ${QRC_CONTENTS_ABS} "${out_depends}" VERBATIM)

  add_custom_target(
	rcc_${activity} ALL
    DEPENDS ${CREATED_RCC}
	COMMENT "Generate ${activity} RCC"
    SOURCES ${CREATED_QRC}
	VERBATIM
  )

endfunction()
