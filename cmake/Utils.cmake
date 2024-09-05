function(group_sources sources)
    foreach(source IN LISTS ${sources})
        get_filename_component(source_path "${source}" PATH)
        file(RELATIVE_PATH source_path_rel "${CMAKE_CURRENT_SOURCE_DIR}" "${source_path}")
        string(REPLACE "/" "\\" source_path_msvc "${source_path_rel}")
        source_group("${source_path_msvc}" FILES "${source}")
    endforeach()
endfunction()