require "sinatra"     # Load the Sinatra web framework
require "data_mapper" # Load the DataMapper database library

require "./database_setup"

class Message
  include DataMapper::Resource

  property :id,         Serial
  property :body,       Text,     required: true
  property :created_at, DateTime, required: true
  property :mood,       Text,   required: true
end

DataMapper.finalize()
DataMapper.auto_upgrade!()

get("/") do
  records = Message.all(order: :created_at.desc)
  erb(:index, locals: { messages: records })
end

post("/messages") do
  message_body = params["body"]
  message_time = DateTime.now
  message_mood = params["mood"]
  mood_message = "Alright"
  if message_mood == "happy" 
    mood_message = File.read("good-messages.txt")
  elsif message_mood == "meh"
    mood_message = File.read("meh-messages.txt")
  elsif message_mood == "sad"
    mood_message = File.read("sad-messages.txt")
  elsif message_mood == "mad"
    mood_message = File.read("bad-messages.txt")
  end
  message = Message.create(body: message_body, created_at: message_time, mood: mood_message)

  if message.saved?
    redirect("/")
  else
    erb(:error)
  end
end