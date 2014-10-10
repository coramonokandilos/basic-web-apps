require "sinatra"     # Load the Sinatra web framework
require "data_mapper" # Load the DataMapper database library
require "sinatra/cookies"
require "sinatra/reloader" if development?

require "./database_setup"

class Message
  include DataMapper::Resource

  property :id,         Serial
  property :body,       Text,     required: true
  property :created_at, DateTime, required: true
  property :mood,       Text,     required: true
  property :likes,      Integer,  required: true
  property :name,       String,   required: true
  
  has n, :comments
  
  def addLike()
    self.likes += 1
  end
end

class Comment
  include DataMapper::Resource
  property :id,        Serial
  property :body,      Text,       required: true
  property :created_at, DateTime,   required: true
  
  belongs_to :message
end

DataMapper.finalize()
DataMapper.auto_upgrade!()

get("/") do
  records = Message.all(order: :created_at.desc)
  erb(:index, locals: { messages: records })
end

get '/jerk.html' do
  erb(:jerk)
end

post ("/messageLike/*") do |id|
  message_liked = "isliked_#{id}"
  if (cookies[message_liked] == "true")
    redirect("/jerk.html")
  else
    records = Message.all(order: :created_at.desc)
    message = Message.get(id)
    message.addLike()
    message.save
    cookies[message_liked] = "true"
    redirect("/")
  end
end

post("/messages") do
  message_body = params["body"]
  message_time = DateTime.now
  message_mood = params["mood"]
  message_name = params["name"]
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
  message = Message.create(body: message_body, name: message_name, created_at: message_time, mood: mood_message, likes: 0)

  if message.saved?
    redirect("/")
  else
    erb(:error)
  end
end
post ("/message/*/comments") do |message_id|
  message = Message.get(message_id)
  comment = Comment.new
  comment.body = params[:comment_body]
  comment.created_at=DateTime.now
  message.comments.push(comment)
  message.save
  redirect("/")
end