local building = {{{0},{0},{0},{0},{0}},{{0},{0},{0},{0},{0}},{{0},{0},{0},{0},{0}},{{0},{0},{0},{0},{0}},{{0},{0},{0},{0},{0}}}  --a 5x5x5 array
local unit = {}
user = { }     --may be moved to user.lua, which will mainly hold tweets (user-created functions) and stats
user.__index = user
user.energy = 9000   --TEMPORARY!
resetter = 1

require("middleclass")
Build = class("Build")

function Build:placeBlock(x,y,z,block)  --obvious arguments
	if resetter == 1 then
		Build:empty(0)
		resetter = 0
	end
	if Build:authenticate(block) == 0 then return "nice try, suckah" end  --checks if someone is trying to cheat (by making a block without paying for energy with: block = { } block.blastRes = 9000 and so on.
  if x ~= nil then	  --bonus: use nil for x then it won't do anything except return 1 for "this block COULD be placed" and 0 for "no energy, suckah!"
		if user.energy >= block.energy then
			building[x][y][z] = block
			user.energy = user.energy - block.energy
			return 1
		else return 0 end
	else if user.energy >= block.energy then return 1 else return 0 end
end
end

function Build:rmBlock(x,y,z,block)  --obvious arguments. Removes block and returns 50% energy. Woot!
	if resetter == 1 then
		Build:empty(0)
		resetter = 0
	end
	if building[x][y][z] == block then
		building[x][y][z] = 0
		local en = block.energy/2
		user.energy = user.energy + en
		return 1
	else return 0 end
end

function Build:suspen(x,y,z,block)  --obvious args. builds a suspension block, which is 1/4 of the size, takes 1/4 of the energy but has 1/4 of the stats...
	if resetter == 1 then
		Build:empty(0)
		resetter = 0
	end
	if Build:authenticate(block) == 0 then return "nice try, suckah" end
	quart = block
	if quart.density ~= nil then quart.density = quart.density/4 end   --add new properties as they come
	if quart.density ~= nil then quart.blastRes = quart.blastRes/4 end
	if quart.float ~= nil then quart.float = quart.float/4 end
	if quart.conductivity ~= nil then quart.conductivity = quart.conductivity/4 end
	quart.cpu = 0
	if quart.explosive ~= nil then quart.explosive = quart.explosive/4 end
	quart.sticky = 1
	if quart.energy ~= nil then quart.energy = quart.energy/4 end
	if quart.radioactive ~= nil or 0 then quart.radioactive = 1 else quart.radioactive = 0 end
	if user.energy >= quart.energy then
		building[x][y][z] = quart
		user.energy = user.energy - quart.energy
		return 1
	else
		return 0
	end
end

function Build:make()   --release the building into the field! yaaaayyy!	
	if resetter == 1 then
		Build:empty(0)
		resetter = 0
	end
	unit = Build:new()
	for x=1,5,1 do
		unit[x] = building[x]  --cp building into unit w/o removing instance status
	end
	for z=1,5,1 do  --for every value of Z test if there are any blocks, if not, block above drops down (GRAVITY!)
		for x=1,5,1 do   --every value of X (I am so glad that I went for 5x5x5, not 10x10x10!)
			for y=1,5,1 do --every value of Y
				if unit[x][y][z] == 0 then     --if there's no block in that place
					if Build:testFloat(x,y,z,unit) == 0 then   --if not sticky or floating then
						local copy = unit[x][y][z+1]  --cut the block above
						unit[x][y][z+1] = 0   --down one level
						unit[x][y][z] =	copy    --and paste
					end
				end
			end
		end
	end
	resetter = 1
	return unit
end

function Build:read(x,y,z)    --forcing it to read, but making it unable to write, building[x][y][z]!
	return building[x][y][z]
end

function Build:readAll()
	return building
end

function Build:empty(restore)  --when called w/ restore == 1, restores 50% energy. if called with restore == 0 (when used by build.make()), it doesn't restore
	for x=1,5,1 do
		for y=1,5,1 do
			for z=1,5,1 do
				if instanceOf(Chem,building[x][y][z]) then
					if restore == 1 then local en = building[x][y][z].energy/2 end
					building[x][y][z] = 0
					if restore == 1 then
						user.energy = user.energy + en
					end
				end
			end
		end
	end
end

function Build:testFloat(x,y,z,unit)
	local density = 0
	for xT=1,5,1 do
		for yT=1,5,1 do
			if instanceOf(Chem,unit[xT][yT][z]) then
				if unit[xT][yT][z].density ~= nil then
					density = density + unit[xT][yT][z].density
				end
			end
		end
	end
	local float = 0
	for xT=1,x,1 do   --check all blocks below stated
		for yT=1,y,1 do
			if instanceOf(Chem,unit[xT][yT][z]) then
				if unit[xT][yT][z].density ~= nil then
					float = float + unit[xT][yT][z].density
				end
			end
		end
	end
	local sticky = 0
	for zT=1,5,1 do
		if x < 5 then
			if instanceOf(Chem,unit[x+1][y][z]) then
				if unit[x+1][y][z].sticky ~= nil then sticky = 1 end
			end
		end
		if x > 1 then
			if instanceOf(Chem,unit[x-1][y][z]) then
				if unit[x-1][y][z].sticky ~= nil then sticky = 1 end
			end
		end
		if y < 5 then
			if instanceOf(Chem,unit[x][y+1][z]) then
				if unit[x][y+1][z].sticky ~= nil then sticky = 1 end
			end
		end
		if y > 1 then
			if instanceOf(Chem,unit[x][y-1][z]) then
				if unit[x][y-1][z].sticky ~= nil then sticky = 1 end
			end
		end
		if instanceOf(Chem,unit[x][y][z]) then
			if unit[x][y][z].sticky ~= nil then
				if x < 5 then
					if instanceOf(Chem,unit[x+1][y][z]) then sticky = 1 end
				end
				if x > 1 then
					if instanceOf(Chem,unit[x-1][y][z]) then sticky = 1 end
				end
				if y < 5 then
					if instanceOf(Chem,unit[x][y+1][z]) then sticky = 1 end
				end
				if y > 1 then
					if instanceOf(Chem,unit[x][y-1][z]) then sticky = 1 end
				end
			end
		end
	end
	if sticky == 1 then
		return 1
	elseif density < float then
		return 1
	else return 0 end
end

function Build:authenticate(instance)
	if instanceOf(Chem,instance) then
		return 1
	else return 0 end
end
