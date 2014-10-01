require "sinatra"     # Load the Sinatra web framework

get("/") do
  message = File.readlines("message-of-the-day.txt").sample()
  list = ""
  for i in 0..5
    card = File.readlines("a2a-cards.txt").sample()
    list.concat("<li>#{card}</li>")
  end
  erb(:a2a, locals: { motd: "#{message}<br>", cards_list: list })
end