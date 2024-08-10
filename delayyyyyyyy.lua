-- delayyyyyyyy
-- by: @cfd90
-- addititons by: @imminent_gloom
--
-- ENC1 delay time
-- ENC2 feedback
-- ENC3 delay send
-- KEY1+ENC1 mix
-- KEY2+ENC2 cutoff
-- KEY1+ENC3 modulation/separation
-- KEY3 max delay send when held

engine.name = "Delayyyyyyyy"
initial_monitor_level = 0
is_alt_held = false
persistence = true

function init()
  setup_levels()
  setup_params()
  
  if persistence == true then
  	params:read('/home/we/dust/data/delayyyyyyyy/state.pset')
  else
    setup_defaults()
  end
  
  
end

function setup_levels()
  -- Turn off monitoring, since the engine has a dry/wet knob.
  -- Saves the level at script launch to restore at cleanup() time.
  initial_monitor_level = params:get("monitor_level")
  params:set("monitor_level", -math.huge)
end

function setup_params()
  params:add_separator()
  
  params:add_control("time", "time", controlspec.new(0.0001, 2, 'exp', 0, 0.3, "s"))
  params:set_action("time", function(x) engine.time(x) end)
  
  params:add_control("feedback", "feedback", controlspec.new(0, 100, 'lin', 1, 0, '%'))
  params:set_action("feedback", function(x) engine.feedback(x / 100) end)
  
  params:add_control("sep", "mod/sep", controlspec.new(0, 100, 'lin', 1, 0, '%'))
  params:set_action("sep", function(x) engine.sep(x / 100 / 100) end)
  
  params:add_control("mix", "mix", controlspec.new(0, 100, 'lin', 1, 0, '%'))
  params:set_action("mix", function(x) engine.mix(((x / 100) * 2) - 1) end)
  
  params:add_control("send", "send", controlspec.new(0, 100, 'lin', 1, 0, '%'))
  params:set_action("send", function(x) engine.delaysend(x / 100)  end)
  
  params:add_control("hp", "hp", controlspec.new(20, 10000, 'exp', 0, 400, "Hz"))
  params:set_action("hp", function(x) engine.highpass(x) end)
  
  params:add_control("lp", "lp", controlspec.new(20, 10000, 'exp', 0, 5000, "Hz"))
  params:set_action("lp", function(x) engine.lowpass(x) end)
end

function setup_defaults()
  params:set("time", 0.2)
  params:set("feedback", 75)
  params:set("sep", 10)
  params:set("mix", 40)
  params:set("send", 20)
  params:set("hp", 400)
  params:set("lp", 5000)
end

function cleanup()
  if persistence == true then
	params:write('/home/we/dust/data/delayyyyyyyy/state.pset')
  end
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
    if is_alt_held then
      params:delta("lp", d)
    else
      params:delta("feedback", d)
    end
  elseif n == 3 then
    if is_alt_held then
      params:delta("sep", d)
    else
      params:delta("send", d)
    end
  end
  
  redraw()
end

function key(n, z)
  if n == 1 then
    is_alt_held = z == 1
  end
  if n == 2 then
    if z == 1 then
      current_feedback = params:get("feedback")
      params:set("feedback", current_feedback * 0.9)
    else
      params:set("feedback", current_feedback)
  end
  if n == 3 then
    if z == 1 then
      current_send = params:get("send")
      params:set("send", 100)
    else
      params:set("send", current_send)
    end
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
  screen.font_face(1)
  screen.font_size(16)
  screen.level(15)
  screen.move(0, 20)
  screen.text("delay")

  levels = {12, 10, 8, 6, 4, 3, 2, 1}

  for i=1,#levels do
    screen.level(levels[i])
    screen.text("y")
  end
end

function draw_params()
  screen.font_size(8)
  screen.font_face(1)
  local l1 = 50
  local l2 = 60
  local p1 = 0
  local p2 = 65
  
  if is_alt_held then
    screen.move(p1, l1)
    draw_param("Mix", "mix")
    
    screen.move(p2, l2)
    draw_param("<->", "sep")
    
    screen.move(p1, l2)
    draw_param("LP", "lp")
  else
    screen.move(p1, l1)
    draw_param("Time", "time")
    
    screen.move(p2, l2)
    draw_param("Send", "send")
    
    screen.move(p1, l2)
    draw_param("FB", "feedback")
  end
end

function draw_param(display_name, name)
  screen.level(15)
  screen.text(display_name .. ": ")
  screen.level(3)
  screen.text(params:string(name))
end
