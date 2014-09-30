require "sinatra"     # Load the Sinatra web framework

get("/") do
  html = ""
  html.concat("<h1>Message of The Day</h1>")
  html.concat("<a href='/message'>See today's message (most excellent).</a>")

  body(html)
end

get("/message") do
  file_contents = File.readlines("message-of-the-day.txt").sample()
  
  html = ""
  html.concat("<h1>Message of the Day</h1>")
  html.concat("<p>Today's message is: #{file_contents}<br><br>")
  html.concat("<a href='/message'>See a new message.</a>")

  body(html)
end