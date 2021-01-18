-- delayyyyyyyy
-- ping pong delay
-- by: @cfd90
--
-- ENC1 length
-- ENC2 feedback
-- ENC3 modulation

engine.name = "Delayyyyyyyy"
initial_monitor_level = 0

function init()
  initial_monitor_level = params:get("monitor_level")
  params:set("monitor_level", -math.huge)
  
  params:add_separator()
  
  params:add_control("length", "length", controlspec.new(0.01, 2, 'lin', 0.01, 0.2, 's'))
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
  
  params:add_control("wet", "wet", controlspec.new(0, 1, 'lin', 0.01, 0.5, ''))
  params:set_action("wet", function(x)
    engine.wet((x * 2) - 1)
  end)
  
  params:add_control("inputs", "input channels", controlspec.new(1, 2, 'lin', 1, 1, ''))
  params:set_action("inputs", function(x)
    if x == 2 then
      engine.inL(0)
      engine.inR(1)
    else
      engine.inL(0)
      engine.inR(0)
    end
  end)
  
  params:set("length", 0.2)
  params:set("fb", 0.2)
  params:set("mod", 0.0)
  params:set("wet", 0.5)
  params:set("inputs", 1)
end

function cleanup()
  params:set("monitor_level", initial_monitor_level)
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
  draw_logo()
  draw_params()
  screen.update()
end

function draw_logo()
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
end

function draw_params()
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
end