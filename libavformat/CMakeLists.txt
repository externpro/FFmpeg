set(lib_name avformat)
set(public_headers
  avformat.h
  avio.h
  version.h
  )
install(FILES ${public_headers} DESTINATION ${incDir}/lib${lib_name})
