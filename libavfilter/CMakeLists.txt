set(lib_name avfilter)
set(public_headers
  asrc_abuffer.h
  avcodec.h
  avfilter.h
  avfiltergraph.h
  buffersink.h
  buffersrc.h
  version.h
  )
install(FILES ${public_headers} DESTINATION ${incDir}/lib${lib_name})
