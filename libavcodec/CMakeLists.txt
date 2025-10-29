set(lib_name avcodec)
set(public_headers
  avcodec.h
  avfft.h
  dv_profile.h
  dxva2.h
  old_codec_ids.h
  qsv.h
  vaapi.h
  vda.h
  vdpau.h
  version.h
  vorbis_parser.h
  xvmc.h
  )
install(FILES ${public_headers} DESTINATION ${incDir}/lib${lib_name})
