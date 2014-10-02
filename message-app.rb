require "sinatra"     # Load the Sinatra web framework

get("/") do
  html = ""
  html.concat("<body style=\"background-color: green\">")
  html.concat("<h1>This is a message from YOUR MOM</h1>")
  html.concat("<a href='/message?mood=good'>Good</a></br>")
  html.concat("<a href='/message?mood=meh'>Meh</a></br>")
  html.concat("<a href='/message?mood=bad'>Bad</a></br>")
  html.concat("</body>")
  body(html)
end

get("/message") do
  mood = params["mood"]
  
  if mood == "good"
    good_contents = File.read("good-messages.txt")
    html = ""
    html.concat("<body style=\"background-color: green\">")
    html.concat("<h1>Message of the Day</h1>")
    html.concat("<p>Today's message is: </br> #{good_contents}")
    html.concat("</body>")
  elsif mood == "meh"
    meh_contents = File.read("meh-messages.txt")
    html = ""
    html.concat("<body style=\"background-color: green\">")
    html.concat("<h1>Message of the Day</h1>")
    html.concat("<p>Today's message is: </br> #{meh_contents}")
    html.concat("</body>")
  elsif mood == "bad"
    bad_contents= File.read("bad-messages.txt")
    html = ""
    html.concat("<body style=\"background-color: green\">")
    html.concat("<h1>Message of the Day</h1>")
    html.concat("<p>Today's message is: </br> #{bad_contents}")
    html.concat("</body>")
  else 
    file_contents = File.read("message-of-the-day.txt")
    html = ""
    html.concat("<body style=\"background-color: green\">")
    html.concat("<h1>Message of the Day</h1>")
    html.concat("<p>Today's message is: #{file_contents}")
    html.concat("</body>")
  end

  body(html)
end
