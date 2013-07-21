Unit = { }
field = {{}}
unit = {{{}}}
p1S = {{3,2},{4,2},{5,2},{6,2}}
p2S = {{3,7},{4,7},{5,7},{6,7}}
p3S = {{2,3},{2,4},{2,5},{2,6}}
p4S = {{7,3},{7,4},{7,5},{7,6}}
playerName = "p1S"  --temporary, will be in twar.declare(who?)

function Unit.init()  --prepares the field
	for x=1,8,1 do
		for y=1,8,1 do
			field[x][y] = 0
		end
	end
end

function Unit.deploy(unitOrig,unitBlocksOrig,square)   --unit & unitBlocks (from build.make) and square, which asks for which of the four spawn points the unit will be spawned into
	local cpu = nil
	for x=1,5,1 do
		for y=1,5,1 do
			for z=1,5,1 do
				--expand unitOrig into unitOrig w/ block values
				unitOrig[x][y][z] = unitBlocksOrig[unitOrig[x][y][z]]
				unitOrig[x][y][z].hp = unitOrig[x][y][z].density + unitOrig[x][y][z].blastRes
				--put unitOrig into unit[7][7][6]
				unit[x+1][y+1][z+1] = unitOrig[x][y][z]
			end
		end
	end
	for z=1,5,1 do  --for every value of Z test if there are any blocks, if not, block above drops down (GRAVITY!)
		for x=1,5,1 do   --every value of X (I am so glad that I went for 5x5x5, not 10x10x10!)
			for y=1,5,1 do --every value of Y
				if unit[x][y][z] == nil then     --if there's no block in that place
					if Unit.testFloat(x,y,z) == 0 then   --if not sticky or floating then
						local copy = unit[x][y][z+1]  --cut the block above
						unit[x][y][z+1] = nil   --down one level
						unit[x][y][z] =	copy    --and paste
					end
				end
				if unit[x][y][z].cpu ~= nil then cpu = 1 end
			end
		end
	end
	--give unit some extra properties:
	if cpu == 1 then unit.cpu = 1   --is it controllable? if not, it's gonna have a hard time...
	elseif cpu == 0 then unit.cpu = nil end
	unit.owner = user.name
	--now place in spawn point <square>
	player = _G[playerName]
	field[player[square][1]][player[square][2]] = unit  --in words: place unit in player 1's first spawn point by the x and y co-ordinates in the table p1S. in other words: ffffuuuuu...
end

--[[ What's next? I hear me ask. Stuff, I announce crazily.
Unit.move(x,y,newX,newY) -- checks for ownership, sentience and if the unit CAN move (power > friction) and then moves it ONE space only (it won't do it if the difference between new and old is > 1).
Unit.rotate(x,y,degrees) -- checks for ownership, sentience and if the unit CAN move (power > friction, ignored if centre block), and then rotates it by degrees (only multiples of 90 are valid).
Unit.on(x,y,blockX,blockY,side) -- checks for ownership, if the block (blockX,blockY) has a CPU val, and then powers side <side>.
Unit.off(x,y,blockX,blockY,side) -- opposite of Unit.on.
Unit.sense(x,y,blockX,blockY,side) -- if sentient, returns 0 if unpowered or 1 if powered.
]]--

local function Unit.testFloat(x,y,z)
	local density = 0
	for xT=1,5,1 do
		for yT=1,5,1 do
			density = density + unit[xT][yT][z].density
		end
	end
	local float = 0
	for xT=1,x,1 do   --check all blocks below stated
		for yT=1,y,1 do
			float = float + unit[xT][yT][z].density
		end
	end
	local sticky = 0
	for zT,5,1 do
		if unit[x+1][y][z].sticky ~= nil then sticky = 1
		elseif unit[x-1][y][z].sticky ~= nil 1 then sticky = 1
		elseif unit[x][y+1][z].sticky ~= nil then sticky = 1
		elseif unit[x][y-1][z].sticky ~= nil then sticky = 1
		elseif unit[x][y][z].sticky ~= nil then
			if unit[x+1][y][z] ~= nil then sticky = 1
			elseif unit[x-1][y][z] ~= nil then sticky = 1
			elseif unit[x][y+1][z] ~= nil then sticky = 1
			elseif unit[x][y-1][z] ~= nil then sticky = 1
			else sticky = 0 end
		else sticky = 0 end
	end
	if sticky == 1 then
		return 1
	elseif density < float then
		return 1
	else return 0 end
end
