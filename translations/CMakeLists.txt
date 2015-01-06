SET_DIRECTORY_PROPERTIES(PROPERTIES CLEAN_NO_CUSTOM 1)

# Files to translate
file(GLOB ACTIVITY_SRCS ../src/core/*.qml ../src/core/*.js ../src/activities/*/*.qml
  ../src/activities/*/*.js)

# Translations handling
SET(TRANSLATIONS_FILES
  gcompris_bg.ts
  gcompris_br.ts
  gcompris_cs.ts
  gcompris_da.ts
  gcompris_de.ts
  gcompris_el.ts
  gcompris_es.ts
  gcompris_fr.ts
  gcompris_gd.ts
  gcompris_gl.ts
  gcompris_hu.ts
  gcompris_lt.ts
  gcompris_lv.ts
  gcompris_nl.ts
  gcompris_nn.ts
  gcompris_pl.ts
  gcompris_pt_BR.ts
  gcompris_ru.ts
  gcompris_sk.ts
  gcompris_sl.ts
  gcompris_sr.ts
  gcompris_sv.ts
  gcompris_ta.ts
  gcompris_th.ts
  gcompris_zh_TW.ts
)

# Set the output dir for the translation files to /bin
foreach(TsSource ${TRANSLATIONS_FILES})
  set_source_files_properties(${TsSource}
  PROPERTIES OUTPUT_LOCATION ${GCOMPRIS_TRANSLATIONS_DIR})
endforeach()

qt5_create_translation(QM_FILES ${ACTIVITY_SRCS} ${TRANSLATIONS_FILES})
add_custom_target(UpdateTranslations DEPENDS ${ACTIVITY_SRCS} ${TRANSLATIONS_FILES})
add_custom_target(BuildTranslations DEPENDS ${QM_FILES})
if(CMAKE_HOST_APPLE)
  install(FILES ${QM_FILES} DESTINATION ${_bundle_bin}/translations)
else()
  install(FILES ${QM_FILES} DESTINATION ${_dest_dir}/translations)
endif()
