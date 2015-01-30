dofile(minetest.get_modpath("destroyer").."/api.lua")
--
mobs:register_mob("destroyer:destro", {
	type = "monster",
	hp_max = 50,
	collisionbox = {-0.27, -0.01, -0.27, 0.27, 1.6, 0.27},
	visual = "mesh",
	mesh = "destro.x",
	textures = {"destro.png"},
	visual_size = {x=4, y=4.7},
	makes_footstep_sound = true,
	view_range = 20,
	walk_velocity = 11.5,
	run_velocity = 43,
	damage = 40,

	drops = {
		{name = "default:junglewood",
		chance = 1,
		min = 3,
		max = 5,},
	},
	light_resistant = true,
	armor = 100,
	drawtype = "front",
	water_damage = 0,
	lava_damage = 0,
	light_damage = 0,sounds = {
		attack = "mobs_fireball",
	},
	attack_type = "shoot",
	arrow = "destroyer:fireball",
	shoot_interval = 0.25,
	sounds = {
		attack = "mobs_fireball",
	},
	animation = {
		stand_start = 0,
		stand_end = 19,
		walk_start = 20,
		walk_end = 35,
		punch_start = 36,
		punch_end = 48,
		speed_normal = 15,
		speed_run = 15,
	},
})
mobs:register_spawn("destroyer:destro", {"default:dirt_with_grass","default:desert_stone", "default:mossycobble"}, 20, -1, 7000, 3, 31000)

mobs:register_arrow("destroyer:fireball", {
	visual = "sprite",
	visual_size = {x=0.455, y=.455},
	--textures = {{name="mobs_fireball.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.5}}}, FIXME
	textures = {"mobs_fireball.png"},
	velocity = 50,
	hit_player = function(self, player)
		local s = self.object:getpos()
		local p = player:getpos()
		local vec = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z}
		player:punch(self.object, 1.0,  {
			full_punch_interval=1.0,
			damage_groups = {fleshy=0},
		}, vec)
		local pos = self.object:getpos()
		for dx=-1,1 do
			for dy=-1,1 do
				for dz=-1,1 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local n = minetest.env:get_node(pos).name
					if minetest.registered_nodes[n].groups.flammable or math.random(1, 100) <= 0 then
						minetest.env:set_node(p, {name="fire:basic_flame"})
					else
						minetest.env:remove_node(p)
					end
				end
			end
		end
	end,
	hit_node = function(self, pos, node)
		for dx=-1,1 do
			for dy=-2,1 do
				for dz=-1,1 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local n = minetest.env:get_node(pos).name
					if minetest.registered_nodes[n].groups.flammable or math.random(1, 100) <= 0 then
						minetest.env:set_node(p, {name="fire:basic_flame"})
					else
						minetest.env:remove_node(p)
					end
				end
			end
		end
	end
})


if minetest.setting_get("log_mods") then
	minetest.log("action", "Everything WILL get burned by destroyer")
end
