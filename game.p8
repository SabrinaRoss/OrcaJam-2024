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
	add_shape(x, y, radius, direction)
	add_shape(x-10, y, radius, -direction)
	add_shape(x+10, y, radius, -direction)
end

function add_shape(x, y, radius, direction) 
	local shape = {
		x = x,
		y = y,
		radius = radius,
		direction = direction,
		col = rnd(15)
	}
	add(shapes, shape)
end

cols_i_like = {}
//add a table of all the colours i want
-->8
// manipulation

function shrink(x, y) 
	radius -= 1
	local new_x = x*cos(0) - y*sin(0)
	local new_y = x*sin(0) + y*cos(0)
	return new_x,new_y
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
			x,y = shrink(x, y)
		end 
		if (state == 2) then
			for s in all(shapes) do
			s.x,s.y,s.direction = bounce(s.x,s.y,s.direction)
			end
		end
end

// add a system for initing induvidual x, y values for each shape

function state_machine_draw() 
	if (state == 1) then
		circfill(x, y, radius, 8)
		circfill(x+margin, y+margin, radius,10)
		circfill(x-margin, y-margin, radius, 12)
	end
	if (state == 2) then
		for s in all(shapes) do
		circfill(s.x,s.y,radius-15,s.col)
		end
	end
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
__gfx__
00000000444444444444444444444444444444444444444400000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000400000044000000440000004400000044000000400000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700400990044009900440099004400990044090900400000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000409009044090900440900904409009044099990400000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000409009044000900440009004400090044000900400000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700400990044099990440090004409009044000900400000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000400000044000000440999904400990044000000400000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000444444444444444444444444444444444444444400000000000000000000000000000000000000000000000000000000000000000000000000000000
