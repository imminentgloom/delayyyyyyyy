-- delayyyyyyyy
-- ping pong delay
-- by: @cfd90
--
-- ENC1 length
-- ENC2 feedback
-- ENC3 modulation

engine.name = "Delayyyyyyyy"

function init()
  print("delayyyyyyyyyyyyyyyyyyyyyy")
  
  params:add_separator()
  
  engine.length(0.2)
  engine.feedback(0.5)
  engine.modulation(0)
  
  params:add_control("length", "length", controlspec.new(0.01, 2, 'lin', 0.01, 0.1, 's'))
  params:set_action("length", function(x)
    engine.length(x)
  end)
  
  params:add_control("fb", "feedback", controlspec.new(0, 1, 'lin', 0.01, 0.5, ''))
  params:set_action("fb", function(x)
    engine.feedback(x)
  end)
  
  params:add_control("mod", "modulation", controlspec.new(0, 1, 'lin', 0.01, 0, ''))
  params:set_action("mod", function(x)
    engine.modulation(x / 100)
  end)
end

function enc(n, d)
  if n == 1 then
    params:delta("length", d)
  elseif n == 2 then
    params:delta("fb", d)
  elseif n == 3 then
    params:delta("mod", d)
  end
  
  redraw()
end

function redraw()
  screen.clear()
  
  screen.font_face(2)
  screen.font_size(18)
  screen.level(15)
  screen.move(0, 20)
  screen.text("delay")
  screen.level(12)
  screen.text("y")
  screen.level(10)
  screen.text("y")
  screen.level(8)
  screen.text("y")
  screen.level(5)
  screen.text("y")
  screen.level(3)
  screen.text("y")
  screen.level(2)
  screen.text("y")
  screen.level(1)
  screen.text("y")
  screen.level(0)
  screen.text("y")
  
  screen.font_size(8)
  screen.move(0, 30)
  screen.level(15)
  screen.text("length: ")
  screen.level(3)
  screen.text(params:get("length") .. "s")
  screen.move(0, 40)
  screen.level(15)
  screen.text("feedback: ")
  screen.level(3)
  screen.text(params:get("fb"))
  screen.move(0, 50)
  screen.level(15)
  screen.text("modulation: ")
  screen.level(3)
  screen.text(params:get("mod"))
  
  screen.update()
end