set(lib_name swresample)
set(public_headers
  swresample.h
  version.h
  )
install(FILES ${public_headers} DESTINATION ${incDir}/lib${lib_name})
