set(PLATFORMSOURCES)

if(WIN32)
    file(GLOB_RECURSE PLATFORMSOURCES ${CMAKE_CURRENT_SOURCE_DIR}/windows/*.cpp ${CMAKE_CURRENT_SOURCE_DIR}/windows/*.h)
    target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/windows)
elseif(UNIX)
    file(GLOB_RECURSE PLATFORMSOURCES ${CMAKE_CURRENT_SOURCE_DIR}/linuxbsd/*.cpp ${CMAKE_CURRENT_SOURCE_DIR}/linuxbsd/*.h)
    target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/linuxbsd)
endif()

# Append the platform-specific sources to the main source files list
list(APPEND SOURCE_FILES ${PLATFORMSOURCES})
