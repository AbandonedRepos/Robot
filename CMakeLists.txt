cmake_minimum_required(VERSION 3.15)
project(RobotEngine)

if(WIN32)
set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake")
endif()

set(CMAKE_CXX_STANDARD 17)

set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)

# Collect all source files
file(GLOB_RECURSE EngineSources 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.h
)

add_subdirectory(deps)

# Function to create source groups based on file directory structure
function(GroupSources curdir sources)
    foreach(source ${${sources}})
        file(RELATIVE_PATH relative_file ${curdir} ${source})
        get_filename_component(dir ${relative_file} PATH)
        string(REPLACE "/" "\\" group ${dir})
        source_group(${group} FILES ${source})
    endforeach()
endfunction()

# Group the sources
GroupSources(${CMAKE_CURRENT_SOURCE_DIR}/src EngineSources)

file(GLOB_RECURSE EngineSources ${CMAKE_CURRENT_SOURCE_DIR}/src/**.cpp ${CMAKE_CURRENT_SOURCE_DIR}/src/**.h)

# add platform specific flags
if(WIN32)
    file(GLOB_RECURSE PLATFORMSOURCES ${CMAKE_CURRENT_SOURCE_DIR}/platform/windows/**.cpp ${CMAKE_CURRENT_SOURCE_DIR}/platform/windows/**.h)
elseif(LINUX)
    file(GLOB_RECURSE PLATFORMSOURCES ${CMAKE_CURRENT_SOURCE_DIR}/platform/linuxbsd/**.cpp ${CMAKE_CURRENT_SOURCE_DIR}/platform/linuxbsd/**.h)
endif()

add_executable(${PROJECT_NAME} ${EngineSources} ${PLATFORMSOURCES})

# add platform specific include directories
if(WIN32)
    target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/platform/windows)
elseif(LINUX)
    target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/platform/linuxbsd)
endif()

target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src/)

find_package(directx-headers CONFIG REQUIRED)
find_package(d3d12-memory-allocator CONFIG REQUIRED)
find_package(ZLIB REQUIRED)
find_package(graphite2 REQUIRED)

target_link_libraries(${PROJECT_NAME} PUBLIC OpenXR OpenXR::headers volk Microsoft::DirectX-Headers unofficial::D3D12MemoryAllocator ZLIB::ZLIB dxgi d3d12 d3dcompiler graphite2)

install(TARGETS ${PROJECT_NAME} LIBRARY DESTINATION lib)
install(DIRECTORY assets/ DESTINATION bin/assets)

if(WIN32)
	target_compile_definitions(${PROJECT_NAME} PUBLIC _WIN32) 
    #define directx
    target_compile_definitions(${PROJECT_NAME} PUBLIC DIRECTX)
endif()

target_compile_definitions(${PROJECT_NAME} PUBLIC TYPED_METHOD_BIND TOOLS_ENABLED USE_VOLK VULKAN_ENABLED)