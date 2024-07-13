set(EngineSources)

function(GroupSources curdir sources)
    foreach(source ${${sources}})
        file(RELATIVE_PATH relative_file ${curdir} ${source})
        get_filename_component(dir ${relative_file} PATH)
        string(REPLACE "/" "\\" group ${dir})
        source_group(${group} FILES ${source})
    endforeach()
endfunction()

GroupSources(${CMAKE_CURRENT_SOURCE_DIR}/src EngineSources)

file(GLOB_RECURSE EngineSources ${CMAKE_CURRENT_SOURCE_DIR}/src/**.cpp ${CMAKE_CURRENT_SOURCE_DIR}/src/**.h ${CMAKE_CURRENT_SOURCE_DIR}/src/**.inl)