
add_subdirectory(activities)
add_subdirectory(core)

if(BUILD_SERVER)
  add_subdirectory(server)
endif(BUILD_SERVER)