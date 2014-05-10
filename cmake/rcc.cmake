function(GCOMPRIS_ADD_RCC activity )

  set(infile ${CMAKE_CURRENT_LIST_DIR}/${activity}.qrc)
  set(outfilename ${CMAKE_BINARY_DIR}/bin/${activity}.rcc)
  get_filename_component(rc_path ${infile} PATH)

  # Code taken from QT5_ADD_RESOURCES
  # We extract the qrc content to add a dependancy on each file it contains
  set(_RC_DEPENDS)
  if(EXISTS "${infile}")
	  #  parse file for dependencies
	  #  all files are absolute paths or relative to the location of the qrc file
	  file(READ "${infile}" _RC_FILE_CONTENTS)
	  string(REGEX MATCHALL "<file[^<]+" _RC_FILES "${_RC_FILE_CONTENTS}")
	  foreach(_RC_FILE ${_RC_FILES})
		  string(REGEX REPLACE "^<file[^>]*>" "" _RC_FILE "${_RC_FILE}")
		  if(NOT IS_ABSOLUTE "${_RC_FILE}")
			  set(_RC_FILE "${rc_path}/${_RC_FILE}")
		  endif()
		  set(_RC_DEPENDS ${_RC_DEPENDS} "${_RC_FILE}")
	  endforeach()
	  # Since this cmake macro is doing the dependency scanning for these files,
	  # let's make a configured file and add it as a dependency so cmake is run
	  # again when dependencies need to be recomputed.
	  qt5_make_output_file("${infile}" "" "qrc.depends" out_depends)
	  configure_file("${infile}" "${out_depends}" COPY_ONLY)
  endif()

  add_custom_command(OUTPUT ${outfilename}
					 COMMAND ${Qt5Core_RCC_EXECUTABLE} "-binary" -o ${outfilename} ${infile}
					 MAIN_DEPENDENCY ${infile}
					 DEPENDS ${_RC_DEPENDS} "${out_depends}" VERBATIM)

#  set(gcompris_RCC ${gcompris_RCC} ${outfilename} CACHE STRING "RccFile" FORCE)

  add_custom_target(
	rcc_${activity} ALL
	DEPENDS ${outfilename}
	COMMENT "Generate ${activity} RCC"
	VERBATIM
  )

endfunction()
