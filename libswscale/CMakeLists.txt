set(lib_name swscale)
set(public_headers
  swscale.h
  version.h
  )
install(FILES ${public_headers} DESTINATION ${incDir}/lib${lib_name})
