-- delayyyyyyyy
-- by: @cfd90
--
-- ENC1 delay time
-- ENC2 feedback
-- ENC3 modulation/separation
-- KEY1+ENC1 mix

engine.name = "Delayyyyyyyy"
initial_monitor_level = 0
is_alt_held = false

function init()
  setup_levels()
  setup_params()
  setup_defaults()
end

function setup_levels()
  -- Turn off monitoring, since the engine has a dry/wet knob.
  -- Saves the level at script launch to restore at cleanup() time.
  initial_monitor_level = params:get("monitor_level")
  params:set("monitor_level", -math.huge)
end

function setup_params()
  params:add_separator()
  
  params:add_control("time", "time", controlspec.new(0.01, 2, 'lin', 0.01, 0.01, 's'))
  params:set_action("time", function(x) engine.time(x) end)
  
  params:add_control("feedback", "feedback", controlspec.new(0, 1, 'lin', 0.01, 0.0, ''))
  params:set_action("feedback", function(x) engine.feedback(x) end)
  
  params:add_control("sep", "mod/sep", controlspec.new(0, 100, 'lin', 0.01, 0, '%'))
  params:set_action("sep", function(x) engine.sep(x / 100 / 100) end)
  
  params:add_control("mix", "mix", controlspec.new(0, 100, 'lin', 1, 0, '%'))
  params:set_action("mix", function(x) engine.mix(((x / 100) * 2) - 1) end)
end

function setup_defaults()
  params:set("time", 0.2)
  params:set("feedback", 0.4)
  params:set("sep", 0.0)
  params:set("mix", 40)
end

function cleanup()
  params:set("monitor_level", initial_monitor_level)
end

function enc(n, d)
  if n == 1 then
    if is_alt_held then
      params:delta("mix", d)
    else
      params:delta("time", d)
    end
  elseif n == 2 then
    params:delta("feedback", d)
  elseif n == 3 then
    params:delta("sep", d)
  end
  
  redraw()
end

function key(n, z)
  if n == 1 then
    is_alt_held = z == 1
  end
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

  levels = {12, 10, 8, 5, 3, 2, 1, 0}

  for i=1,#levels do
    screen.level(levels[i])
    screen.text("y")
  end
end

function draw_params()
  screen.font_size(8)
  
  screen.move(0, 30)
  draw_param("time", "time")
  
  screen.move(0, 40)
  draw_param("feedback", "feedback")
  
  screen.move(0, 50)
  draw_param("mod/sep", "sep")
  
  screen.move(60, 30)
  draw_param("mix", "mix")
end

function draw_param(display_name, name)
  screen.level(15)
  screen.text(display_name .. ": ")
  screen.level(3)
  screen.text(params:string(name))
end