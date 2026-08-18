include(CheckLibraryExists)
function(checkLibraryConcat lib symbol liblist)
  string(TOUPPER ${lib} LIB)
  check_library_exists("${lib}" "${symbol}" "" XP_FFMPEG_HAS_${LIB})
  if(XP_FFMPEG_HAS_${LIB})
    list(APPEND ${liblist} ${lib})
    set(${liblist} ${${liblist}} PARENT_SCOPE)
  endif()
endfunction()
# _ffmpeg_*_libs
checkLibraryConcat(asound snd_strerror _ffmpeg_avdevice_libs)
checkLibraryConcat(Xext XShmDetach _ffmpeg_avdevice_libs)
set(_ffmpeg_avcodec_libs openh264::openh264)
# _ffmpeg_*_deps
set(_ffmpeg_avdevice_deps avfilter avformat)
if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  find_library(Cocoa_LIB Cocoa)
  find_library(AVFoundation_LIB AVFoundation)
  find_library(CoreMedia_LIB CoreMedia)
  find_library(VideoDecodeAcceleration_LIB VideoDecodeAcceleration)
  find_library(QuartzCore_LIB QuartzCore)
  set(_ffmpeg_avdevice_libs
    ${Cocoa_LIB}
    ${AVFoundation_LIB}
    ${CoreMedia_LIB}
    ${VideoDecodeAcceleration_LIB}
    ${QuartzCore_LIB}
    )
endif()
set(_ffmpeg_avfilter_deps avcodec swresample swscale) # libavfilter code calls swr_*, sws_* functions
set(_ffmpeg_avformat_deps avcodec)
set(_ffmpeg_avcodec_deps swresample) # libavcodec code calls swr_* functions
set(_ffmpeg_swresample_deps avutil)
set(_ffmpeg_swscale_deps avutil)
set(_ffmpeg_avutil_deps)
# this file (FFmpeg-targets) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
set(includeDirs ${XP_ROOTDIR}/include ${XP_ROOTDIR}/include/ffmpeg)
foreach(lib ${ffmpeg_all_libs})
  if(NOT TARGET FFmpeg::${lib})
    add_library(FFmpeg::${lib} STATIC IMPORTED)
    set(${lib}_RELEASE ${XP_ROOTDIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${lib}${CMAKE_STATIC_LIBRARY_SUFFIX})
    if(EXISTS "${${lib}_RELEASE}")
      set_property(TARGET FFmpeg::${lib} APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
      set_target_properties(FFmpeg::${lib} PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "ASM_NASM;C;CXX"
        IMPORTED_LOCATION_RELEASE "${${lib}_RELEASE}"
        )
      set_target_properties(FFmpeg::${lib} PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${includeDirs}"
        )
      if(_ffmpeg_${lib}_deps OR _ffmpeg_${lib}_libs)
        unset(linkLibs)
        foreach(dep ${_ffmpeg_${lib}_deps})
          list(APPEND linkLibs \$<LINK_ONLY:FFmpeg::${dep}>)
        endforeach()
        foreach(dep ${_ffmpeg_${lib}_libs})
          list(APPEND linkLibs \$<LINK_ONLY:${dep}>)
        endforeach()
        set_target_properties(FFmpeg::${lib} PROPERTIES
          INTERFACE_LINK_LIBRARIES "${linkLibs}"
          )
      endif()
    endif()
  endif()
endforeach()
