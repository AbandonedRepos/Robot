cmake_minimum_required(VERSION 3.15)
project(RobotEngine)

if(WIN32)
set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake")
endif()

set(CMAKE_CXX_STANDARD 17)

set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)

if(MSVC)
    add_compile_options(/MP)
endif()

# Collect all source files
file(GLOB_RECURSE EngineSources 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.h
)

set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build (Debug or Release)" FORCE)


option(DEBUG_ENABLED "enables debugging *features* and debug-only code, which is intended to give *users* extra debugging information for their game development." OFF)
option(DEV_ENABLED "Enable dev mode for those working on the engine" OFF)
option(threads "Enable threading support" ON)

# Components
option(deprecated "Enable compatibility code for deprecated and removed features" ON)
set_property(CACHE deprecated PROPERTY STRINGS ON OFF)

#option(precision "Set the floating-point precision level" "single" "single;double")
#set_property(CACHE precision PROPERTY STRINGS single double)

option(minizip "Enable ZIP archive support using minizip" ON)

option(brotli "Enable Brotli for decompression and WOFF2 fonts support" ON)

option(xaudio2 "Enable the XAudio2 audio driver" OFF)

option(vulkan "Enable the vulkan rendering driver" ON)

option(opengl3 "Enable the OpenGL/GLES3 rendering driver" ON)

option(d3d12 "Enable the Direct3D 12 rendering driver" OFF)

option(openxr "Enable the OpenXR driver" ON)

option(use_volk "Use the volk library to load the Vulkan loader dynamically" ON)

option(disable_exceptions "Force disabling exception handling code" ON)

set(custom_modules "" CACHE STRING "A list of comma-separated directory paths containing custom modules to build.")
option(custom_modules_recursive "Detect custom modules recursively for each specified path." ON)

# Advanced options
option(DEV_MODE "Alias for dev options: verbose=yes warnings=extra werror=yes tests=yes" OFF)
option(TESTS "Build the unit tests" OFF)
option(FAST_UNSAFE "Enable unsafe options for faster rebuilds" OFF)
option(NINJA "Use the ninja backend for faster rebuilds" OFF)
option(COMPILEDB "Generate compilation DB (`compile_commands.json`) for external tools" OFF)
option(VERBOSE "Enable verbose output for the compilation" OFF)
option(PROGRESS "Show a progress indicator during compilation" ON)
set(WARNINGS "all" CACHE STRING "Level of compilation warnings" )
set_property(CACHE WARNINGS PROPERTY STRINGS "extra" "all" "moderate" "no")
option(WERROR "Treat compiler warnings as errors" OFF)
set(EXTRA_SUFFIX "" CACHE STRING "Custom extra suffix added to the base filename of all generated binary files")
set(OBJECT_PREFIX "" CACHE STRING "Custom prefix added to the base filename of all generated object files")
option(VSPROJ "Generate a Visual Studio solution" OFF)
set(VSPROJ_NAME "godot" CACHE STRING "Name of the Visual Studio solution")
set(IMPORT_ENV_VARS "" CACHE STRING "A comma-separated list of environment variables to copy from the outer environment.")
option(DISABLE_3D "Disable 3D nodes for a smaller executable" OFF)
option(DISABLE_ADVANCED_GUI "Disable advanced GUI nodes and behaviors" OFF)
set(BUILD_PROFILE "" CACHE STRING "Path to a file containing a feature build profile")
option(MODULES_ENABLED_BY_DEFAULT "If no, disable all modules except ones explicitly enabled" ON)
option(NO_EDITOR_SPLASH "Don't use the custom splash screen for the editor" ON)
set(SYSTEM_CERTS_PATH "" CACHE STRING "Use this path as TLS certificates default for editor and Linux/BSD export templates (for package maintainers)")
option(USE_PRECISE_MATH_CHECKS "Math checks use very precise epsilon (debug option)" OFF)
option(SCU_BUILD "Use single compilation unit build" OFF)
set(SCU_LIMIT "0" CACHE STRING "Max includes per SCU file when using scu_build (determines RAM use)")
option(ENGINE_UPDATE_CHECK "Enable engine update checks in the Project Manager" ON)
option(STEAMAPI "Enable minimal SteamAPI integration for usage time tracking (editor only)" OFF)

# Thirdparty libraries
option(BUILTIN_BROTLI "Use the built-in Brotli library" ON)
option(BUILTIN_CERTS "Use the built-in SSL certificates bundles" ON)
option(BUILTIN_CLIPPER2 "Use the built-in Clipper2 library" ON)
option(BUILTIN_EMBREE "Use the built-in Embree library" ON)
option(BUILTIN_ENET "Use the built-in ENet library" ON)
option(BUILTIN_FREETYPE "Use the built-in FreeType library" ON)
option(BUILTIN_MSDFGEN "Use the built-in MSDFgen library" ON)
option(BUILTIN_GLSLANG "Use the built-in glslang library" ON)
option(BUILTIN_GRAPHITE "Use the built-in Graphite library" ON)
option(BUILTIN_HARFBUZZ "Use the built-in HarfBuzz library" ON)
option(BUILTIN_ICU4C "Use the built-in ICU library" ON)
option(BUILTIN_LIBOGG "Use the built-in libogg library" ON)
option(BUILTIN_LIBPNG "Use the built-in libpng library" ON)
option(BUILTIN_LIBTHEORA "Use the built-in libtheora library" ON)
option(BUILTIN_LIBVORBIS "Use the built-in libvorbis library" ON)
option(BUILTIN_LIBWEBP "Use the built-in libwebp library" ON)
option(BUILTIN_WSLAY "Use the built-in wslay library" ON)
option(BUILTIN_MBEDTLS "Use the built-in mbedTLS library" ON)
option(BUILTIN_MINIUPNPC "Use the built-in miniupnpc library" ON)
option(BUILTIN_OPENXR "Use the built-in OpenXR library" ON)
option(BUILTIN_PCRE2 "Use the built-in PCRE2 library" ON)
option(BUILTIN_PCRE2_WITH_JIT "Use JIT compiler for the built-in PCRE2 library" ON)
option(BUILTIN_RECASTNAVIGATION "Use the built-in Recast navigation library" ON)
option(BUILTIN_RVO2_2D "Use the built-in RVO2 2D library" ON)
option(BUILTIN_RVO2_3D "Use the built-in RVO2 3D library" ON)
option(BUILTIN_SQUISH "Use the built-in squish library" ON)
option(BUILTIN_XATLAS "Use the built-in xatlas library" ON)
option(BUILTIN_ZLIB "Use the built-in zlib library" ON)
option(BUILTIN_ZSTD "Use the built-in Zstd library" ON)

add_executable(${PROJECT_NAME} ${EngineSources})

add_subdirectory(deps)
add_subdirectory(platform)
add_subdirectory(src)

target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src/)

find_package(directx-headers CONFIG REQUIRED)
find_package(d3d12-memory-allocator CONFIG REQUIRED)
find_package(ZLIB REQUIRED)
find_package(zstd CONFIG REQUIRED)

target_link_libraries(${PROJECT_NAME} PUBLIC OpenXR OpenXR::headers volk Microsoft::DirectX-Headers unofficial::D3D12MemoryAllocator ZLIB::ZLIB dxgi d3d12 d3dcompiler graphite2 
#embree
Recast
vhacd
zstd::libzstd
brotlicommon
brotlidec
brotlienc
)

install(TARGETS ${PROJECT_NAME} LIBRARY DESTINATION lib)
install(DIRECTORY assets/ DESTINATION bin/assets)

if(WIN32)
	target_compile_definitions(${PROJECT_NAME} PUBLIC _WIN32) 
    #define directx
    target_compile_definitions(${PROJECT_NAME} PUBLIC DIRECTX)
endif()

target_compile_definitions(${PROJECT_NAME} PUBLIC TYPED_METHOD_BIND TOOLS_ENABLED USE_VOLK VULKAN_ENABLED BROTLI_ENABLED MINIZIP_ENABLED)

if (DEBUG_ENABLED)
    target_compile_definitions(${PROJECT_NAME} PUBLIC DEBUG_ENABLED)
endif()

if (DEV_ENABLED)
    target_compile_definitions(${PROJECT_NAME} PUBLIC DEV_ENABLED)
else()
    target_compile_definitions(${PROJECT_NAME} PUBLIC NDEBUG)
endif()

if (threads)
    target_compile_definitions(${PROJECT_NAME} PUBLIC THREADS_ENABLED)
endif()

if(minizip)
    target_compile_definitions(${PROJECT_NAME} PUBLIC MINIZIP_ENABLED)
endif()

if(xaudio2)
    target_compile_definitions(${PROJECT_NAME} PUBLIC XAUDIO2_ENABLED)
endif()

if(DISABLE_3D)
    target_compile_definitions(${PROJECT_NAME} PUBLIC _3D_DISABLED)
endif()