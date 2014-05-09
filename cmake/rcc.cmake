function(GCOMPRIS_ADD_RCC activity )

  set(infile ${CMAKE_CURRENT_LIST_DIR}/${activity}.qrc)
  set(outfilename ${CMAKE_BINARY_DIR}/bin/${activity}.rcc)
  add_custom_command(OUTPUT ${outfilename}
					 COMMAND ${Qt5Core_RCC_EXECUTABLE} "-binary" -o ${outfilename} ${infile}
					 MAIN_DEPENDENCY ${infile} VERBATIM)

  set(gcompris_RCC ${gcompris_RCC} ${outfilename} CACHE STRING "RccFile" FORCE)

  add_custom_target(
	rcc_${activity} ALL
	DEPENDS ${outfilename}
	COMMENT "Generate ${activity} RCC"
	VERBATIM
  )

endfunction()
