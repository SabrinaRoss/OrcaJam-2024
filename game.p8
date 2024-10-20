pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _draw()
	cls()
	state_machine_draw()
	if show_state then draw_state_ui() end
end

function _update()
	input_check()
	if (time() - last > .03) then
		last = time()
		state_machine_update()
		if radius == 0 then radius = 30 end
	end
end

function _init()
	state = 0
	cam_max = 128
	reset_variables()
	max_states = 5 // idk why doing this but o'well
	show_state = true
	last = time()
end

function input_check()
 if btnp((❎)) then 
 	if show_state then show_state = false
 	else show_state = true end
 end
 	if (show_state) then
		if state < 0 then state += 1 end
		if state > max_states-1 then state -= 1 end
		if btnp((⬇️)) then state -= 1 reset_variables() end
		if btnp((⬆️)) then state += 1 reset_variables() end
	end
end

function reset_variables() 
	shapes = {} //table of shape instances
	x = 64
	y = 64
	margin = 40
	radius = 20
	byte = 8
	angle = 0
	direction = 1
	state_reset_shape()
end

function add_shape(x, y, radius, direction) 
	local shape = {
		x = x,
		y = y,
		radius = radius,
		direction = direction,
		col = rnd(cols_i_like)
	}
	add(shapes, shape)
end

cols_i_like = {8,9,10,11,12,14}
//add a table of all the colours i want
-->8
// manipulation

function shrink(radius,direction) 
	local new_radius = radius - 1
	if (new_radius <= 0) then direction *= -1 end
	return new_radius,direction
end

function expand(radius,direction)
	local new_radius = radius + 1
	if (new_radius >= 20) then direction *= -1 end
	return new_radius, direction
end

function bounce(x,y,direction)
	local new_x = x
	local new_y = y + 3*direction
	if (new_y >= cam_max - radius) then 
		new_y -= 3*direction 
		direction *= -1 
	end
	if (new_y <= 0 + radius) then 
		new_y -= 3*direction 
		direction *= -1 
	end
	return new_x, new_y,direction
end

function make_square(start_x,start_y, width, height)
	for i=start_x-16, start_x+width-1,6 do
		for j=start_y-16,start_y+height-1,6 do
			add_shape(i,j,3,1)
		end
		end
end

function rotate(x,y,o_x,o_y,angle)
  local s = sin(angle)
  local c = cos(angle)

  px = x - o_x
  py = y - o_y

  local new_x = px * c - py * s
  local new_y = px * s + py * c

  new_x = new_x + o_x
  new_y = new_y + o_y

  return new_x, new_y
end

//	for y=-r,r,3 do
//		for x=-r,r,2 do
//			local dist=sqrt(x*x+y*y)
//			z=cos(dist/40-t())*6
//			pset(r+x,r+y-z,6)
//		end
//	end
-->8
// state machine

function state_machine_update() 
		if (state == 1) then
			for s in all(shapes) do
			if s.direction == 1 then s.radius,s.direction = shrink(s.radius,s.direction) end
			if s.direction == -1 then s.radius,s.direction = expand(s.radius,s.direction) end
			
			end
		end 
		if (state == 2) then
			for s in all(shapes) do
			s.x,s.y,s.direction = bounce(s.x,s.y,s.direction)
			end
		end
		if (state == 3) then
		for s in all(shapes) do
			s.x,s.y = rotate(s.x,s.y,64,64,angle)
		end
	end
end

// add a system for initing induvidual x, y values for each shape

function state_machine_draw() 
	if (state == 0) then draw_title() end
	if (state == 1) then
		for s in all(shapes) do
		circfill(s.x,s.y,s.radius,s.col)
		end
	end
	if (state == 2) then
		for s in all(shapes) do
		circfill(s.x,s.y,s.radius-15,s.col)
		end
	end
	if (state == 3) then
		for s in all(shapes) do
		circfill(s.x,s.y,s.radius,s.col)
		end
	end
end

function state_reset_shape()
	if (state == 1) then state_1_spawn() end
	if (state == 2) then state_2_spawn() end
	if (state == 3) then state_3_spawn() end
end

function state_1_spawn()
	add_shape(x, y, radius, direction)
	add_shape(x-margin, y-margin, radius, direction)
	add_shape(x+margin, y+margin, radius, direction)
	add_shape(x-margin, y+margin, radius, direction)
	add_shape(x+margin, y-margin, radius, direction)
end

function state_2_spawn()
	add_shape(x, y, radius, direction)
	for i=1,6 do
	if i % 2 == 0 then
	add_shape(x-10*i, y, radius, direction)
	add_shape(x+10*i, y, radius, direction)
	else
	add_shape(x-10*i, y, radius, -direction)
	add_shape(x+10*i, y, radius, -direction)
	end
	end
end

function state_3_spawn()
	for i = 0, 8,2 do
		make_square(x+i,y+i,10,10)
	end
	angle = .004
end
-->8
// sprites

function draw_state_ui()
	for i = max_states, 0, -1 do
		spr(i, cam_max - (byte), cam_max - (byte * i))
		if (state == i) then
			rect(cam_max - (byte), cam_max - (byte * i)-1, cam_max-1, cam_max-(i*byte)-byte, 3)
		end
	end
end

function draw_title()
	print("welcome to: ",36,28,7)
	print("rowans world!",32,36,7)
	print("controls:	⬆️⬇️❎",6,120,7)
	print("this is a collage",22,48+2*byte)
	print("of cool effects",26,56+2*byte)
	print("that i like",34,64+2*byte)
end
__gfx__
00000000444444444444444444444444444444444444444400000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000400000044000000440000004400000044000000400000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700400990044009900440099004400990044090900400000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000409009044090900440900904409009044099990400000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000409009044000900440009004400090044000900400000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700400990044099990440090004409009044000900400000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000400000044000000440999904400990044000000400000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000444444444444444444444444444444444444444400000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000010000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000000000000000000000000290502c0502f0503105033050340503505034050320502e050290502c050260502305022050250502a050310503b05014050110500f050000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000210501d05023050290500b05031030320300a0303105006050230501b0502a0502e050300501906020060200601a070290702d0703007032070330702d0701505024050290500b0502e0501305018050
001000001f05025050280502c0502e0502f0502f0502e0502c0502b050250501c050210502505027050290502b0502b0502a05028050250501c0701f07022070240702407022070210601f06018060110700b070
00100000170501f05026050280502c0502e050300502f0502e0502c0500e0500e05011050000001c050200502305027050280502a0502b0502c0502c0502c0502b0502a050070500705008050000000000000000
