cmake_minimum_required(VERSION 3.31)
set(CMAKE_PROJECT_TOP_LEVEL_INCLUDES .devcontainer/cmake/xproinc.cmake)
project(FFmpeg)
include(GNUInstallDirs)
include(xpflags)
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
  "string(REPLACE \";\" \" \" ffmpeg_all_libs \"\${ffmpeg_all_libs}\")"
  "# FFMPEG_LIBRARIES - the FFmpeg libraries"
  "set(FFMPEG_LIBRARIES \${ffmpeg_all_libs})"
  "list(TRANSFORM FFMPEG_LIBRARIES PREPEND ffmpeg::)"
  "list(APPEND reqVars FFMPEG_LIBRARIES)"
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
    "string(REPLACE \";\" \" \" FFMPEG_DLLNAMES \"\${FFMPEG_DLLNAMES}\")"
    "# FFMPEG_DLLS - the full path to FFmpeg shared objects (dll, so)"
    "set(FFMPEG_DLLS \${FFMPEG_DLLNAMES})"
    "list(TRANSFORM FFMPEG_DLLS PREPEND \${XP_ROOTDIR}/${CMAKE_INSTALL_BINDIR}/)"
    "list(APPEND reqVars FFMPEG_DLLNAMES FFMPEG_DLLS)"
    ""
    )
endif()
if(NOT DEFINED XP_INSTALL_CMAKEDIR)
  set(XP_INSTALL_CMAKEDIR ${CMAKE_INSTALL_DATADIR}/cmake)
endif()
set(targetsFile ${PROJECT_NAME}-targets)
xpPackageDevel(TARGETS_FILE ${targetsFile} DEPS openh264)
install(FILES cmake/${targetsFile}.cmake DESTINATION ${XP_INSTALL_CMAKEDIR})
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  string(TOLOWER ${PROJECT_NAME} prj)
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
endif()
