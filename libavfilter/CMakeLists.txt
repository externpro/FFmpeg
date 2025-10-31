set(lib_name avfilter)
set(public_headers
  avfilter.h
  buffersink.h
  buffersrc.h
  version.h
  )
install(FILES ${public_headers} DESTINATION ${incDir}/lib${lib_name})
