cmake_minimum_required(VERSION 3.31)
set(CMAKE_PROJECT_TOP_LEVEL_INCLUDES .devcontainer/cmake/xproinc.cmake)
project(FFmpeg)
set(libs # libraries, in linking order
  # https://github.com/FFmpeg/FFmpeg/blob/n2.6.2/configure#L2667-L2675
  avdevice
  avfilter
  avformat
  avcodec
  swresample
  swscale
  avutil
  )
string(JOIN "\n" EXT1
  "# libraries, in linking order"
  "# https://github.com/FFmpeg/FFmpeg/blob/n2.6.2/configure#L2667-L2675"
  "# TRICKY ffmpeg_all_libs used by FFmpeg-targets.cmake"
  "set(ffmpeg_all_libs ${libs})"
  ""
  )
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  foreach(lib ${libs})
    string(TOUPPER ${lib} LIB)
    file(READ "lib${lib}/version.h" VERSION_H_CONTENTS)
    string(REGEX MATCH "#define[ \t]+LIB${LIB}_VERSION_MAJOR[ \t]+([0-9]+)" _ ${VERSION_H_CONTENTS})
    set(VERSION_MAJOR ${CMAKE_MATCH_1})
    list(APPEND dlls ${lib}-${VERSION_MAJOR}.dll)
  endforeach()
  string(JOIN "\n" EXT3
    "# FFMPEG_DLLNAMES - the FFmpeg shared object names (dll, so)"
    "set(FFMPEG_DLLNAMES ${dlls})"
    "# FFMPEG_DLLS - the full path to FFmpeg shared objects (dll, so)"
    "set(FFMPEG_DLLS \${FFMPEG_DLLNAMES})"
    "list(TRANSFORM FFMPEG_DLLS PREPEND \${XP_ROOTDIR}/${CMAKE_INSTALL_BINDIR}/)"
    "list(APPEND reqVars FFMPEG_DLLNAMES FFMPEG_DLLS)"
    ""
    )
endif()
set(targetsFile ${PROJECT_NAME}-targets)
xpExternPackage(NAMESPACE ffmpeg
  TARGETS_FILE ${targetsFile} LIBRARIES ${libs}
  BASE n2.6.2 XPDIFF "bin(msw), native(unix)" DEPS openh264 PVT_DEPS yasm
  WEB "https://www.ffmpeg.org/" UPSTREAM "github.com/FFmpeg/FFmpeg"
  DESC "complete, cross-platform solution to record, convert and stream audio and video"
  LICENSE "[LGPL-2.1](https://www.ffmpeg.org/legal.html 'LGPL version 2.1 or later')"
  )
install(FILES cmake/${targetsFile}.cmake DESTINATION ${CMAKE_INSTALL_CMAKEDIR})
string(TOLOWER ${PROJECT_NAME} prj)
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  set(mswLibs ${libs})
  list(TRANSFORM mswLibs PREPEND "mswbin/bin/")
  list(TRANSFORM mswLibs APPEND "${CMAKE_STATIC_LIBRARY_SUFFIX}")
  set(mswDlls ${dlls})
  list(TRANSFORM mswDlls PREPEND "mswbin/bin/")
  install(FILES ${mswLibs} DESTINATION ${CMAKE_INSTALL_LIBDIR})
  install(PROGRAMS ${mswDlls} DESTINATION ${CMAKE_INSTALL_BINDIR})
  set(incDir ${CMAKE_INSTALL_INCLUDEDIR}/${prj})
  foreach(lib ${libs})
    add_subdirectory(lib${lib}) # each library installs headers to incDir
  endforeach()
else()
  find_package(openh264)
  find_package(yasm)
  get_filename_component(yasmBinDir ${xpuse-yasm_DIR}/../../bin ABSOLUTE)
  configure_file(${xpuse-openh264_DIR}/openh264.pc.in ${CMAKE_BINARY_DIR}/openh264.pc @ONLY)
  set(XP_CONFIGURE ${CMAKE_COMMAND} -E env PKG_CONFIG_PATH=${CMAKE_BINARY_DIR}
    PATH=${yasmBinDir}:$ENV{PATH} # prepend path to yasm
    <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> #--enable-shared --disable-static
    --enable-pic --disable-bzlib --disable-iconv
    --disable-libxcb --disable-libxcb-shm --disable-libxcb-xfixes --disable-libxcb-shape
    --disable-lzma --disable-xlib --disable-zlib
    )
  list(APPEND XP_CONFIGURE --enable-libopenh264 --disable-sdl)
  list(APPEND XP_CONFIGURE --disable-debug)
  xpVerboseListing("[CONFIGURE]" "${XP_CONFIGURE}")
  include(ExternalProject)
  set_property(DIRECTORY PROPERTY EP_BASE ${CMAKE_BINARY_DIR}/epbase)
  ExternalProject_Add(${PROJECT_NAME}
    SOURCE_DIR ${CMAKE_SOURCE_DIR}
    CONFIGURE_COMMAND ${XP_CONFIGURE}
    BUILD_COMMAND ${CMAKE_COMMAND} -E env PATH=${yasmBinDir}:$ENV{PATH} make # prepend path to yasm
    INSTALL_COMMAND # use default
    )
  ExternalProject_Get_Property(${PROJECT_NAME} INSTALL_DIR)
  install(DIRECTORY ${INSTALL_DIR}/bin/ DESTINATION ${CMAKE_INSTALL_BINDIR} USE_SOURCE_PERMISSIONS)
  install(DIRECTORY ${INSTALL_DIR}/include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${prj})
  list(TRANSFORM libs PREPEND "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}")
  list(TRANSFORM libs APPEND "${CMAKE_STATIC_LIBRARY_SUFFIX}")
  install(FILES ${libs} DESTINATION lib) # TRICKY: NOT ${CMAKE_INSTALL_LIBDIR} because FFmpeg-targets expects lib
  install(DIRECTORY ${INSTALL_DIR}/share/ DESTINATION ${CMAKE_INSTALL_DATADIR})
endif()
