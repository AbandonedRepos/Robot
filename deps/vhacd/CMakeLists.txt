file(GLOB SOURCES src/*.cpp src/*.inl)
add_library(vhacd ${SOURCES})

set_target_properties(vhacd PROPERTIES DEBUG_POSTFIX -d)

set(Recast_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/inc")

target_include_directories(vhacd PUBLIC
    "$<BUILD_INTERFACE:${Recast_INCLUDE_DIR}>"
)

set_target_properties(vhacd PROPERTIES
        SOVERSION ${SOVERSION}
        VERSION ${LIB_VERSION}
        COMPILE_PDB_OUTPUT_DIRECTORY .
        COMPILE_PDB_NAME "vhacd-d"
        )

install(TARGETS vhacd
        EXPORT recastnavigation-targets
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT library
        INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR} ${CMAKE_INSTALL_INCLUDEDIR}/recastnavigation
        )

file(GLOB INCLUDES inc/*.h)
install(FILES ${INCLUDES} DESTINATION
    ${CMAKE_INSTALL_INCLUDEDIR}/recastnavigation)
if(MSVC)
    install(FILES "$<TARGET_FILE_DIR:vhacd>/vhacd-d.pdb" CONFIGURATIONS "Debug" DESTINATION "lib" OPTIONAL)
endif()
