set(lib_name avdevice)
set(public_headers
  avdevice.h
  version.h
  )
install(FILES ${public_headers} DESTINATION ${incDir}/lib${lib_name})
