require "sinatra"     # Load the Sinatra web framework
require "data_mapper" # Load the DataMapper database library

require "./database_setup"

class Message
  include DataMapper::Resource

  property :id,         Serial
  property :has_image,  Boolean,  required: true, default: false
  property :body,       Text,     required: true
  property :upvotes,    Integer,  required: true, default: 0
  property :created_at, DateTime, required: true
end

DataMapper.finalize()
DataMapper.auto_upgrade!()

helpers do
  def format_newlines(str)
    str.gsub("\n", "<br>")
  end
  def format_timestamp(time)
    time.strftime("%B %d, %Y at %l:%M%p")
  end
end

get("/") do
  file_contents = File.readlines("message-of-the-day.txt").sample()
  # Behind the scenes, running the query:
  #   SELECT * FROM messages ORDER BY created_at DESC
  records = Message.all(order: :created_at.desc)
  erb(:index, locals: { messages: records, motd: "<center>#{file_contents}</center><br>" })
end

get("/admin") do
  file_contents = File.readlines("message-of-the-day.txt").sample()
  erb(:admin, locals: { motd: "<center>#{file_contents}</center><br>" })
end

get("/admin/delete") do
  Message.all.destroy
  html = "All Messages are gone!"
  html.concat("<br><br><a href = '/admin'>Go back?</a>")
  body(html)
end

post("/newpost") do
  message_body = params["body"]
  message_time = DateTime.now
  message_hasimage = [true, false].sample()

  message = Message.create(body: message_body, created_at: message_time, has_image: message_hasimage)

  if message.saved?
    redirect("/")
  else
    erb(:error)
  end
end

post("/messages/*/upvote") do |message_id|
  message = Message.get(message_id)
  message.upvotes = message.upvotes + 1

  if message.save
    redirect("/")
  else
    body("Something went terribly wrong!")
  end
end