# a minimal rack app that displays your running processes on the OOD web host
run Proc.new { |env|
  content = "<h2>Process list generated at: #{Time.now}</h2>"
  content += "<pre>" + `ps ufx` + "</pre>"

  ['200', {'Content-Type' => 'text/html'}, [content]]
}

