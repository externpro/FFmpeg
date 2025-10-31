set(lib_name avcodec)
set(public_headers
  ac3_parser.h
  adts_parser.h
  avcodec.h
  avdct.h
  avfft.h
  bsf.h
  codec_desc.h
  codec_id.h
  codec_par.h
  codec.h
  d3d11va.h
  dirac.h
  dv_profile.h
  dxva2.h
  jni.h
  mediacodec.h
  packet.h
  qsv.h
  vaapi.h
  vdpau.h
  version.h
  videotoolbox.h
  vorbis_parser.h
  xvmc.h
  )
install(FILES ${public_headers} DESTINATION ${incDir}/lib${lib_name})
