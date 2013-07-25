Unit = { }
field = {{}}
unit = {{{}}}
p1S = {{3,2},{4,2},{5,2},{6,2}}
p2S = {{3,7},{4,7},{5,7},{6,7}}
p3S = {{2,3},{2,4},{2,5},{2,6}}
p4S = {{7,3},{7,4},{7,5},{7,6}}
up = {{1,8},{2,8},{3,8},{4,8},{5,8},{6,8},{7,8},{8,8}}
down = {{1,1},{2,1},{3,1},{4,1},{5,1},{6,1},{7,1},{8,1}}
left = {{1,8},{1,7},{1,6},{1,5},{1,4},{1,3},{1,2},{1,1}}
right = {{8,8},{8,7},{8,6},{8,5},{8,4},{8,3},{8,2},{8,1}}
tests = {{1,0,0},{-1,0,0},{0,1,0},{0,-1,0},{0,0,1},{0,0,-1}}
offit = { }

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
				if unitOrig[x][y][z] ~= nil then
					--expand unitOrig into unitOrig w/ block values
					unitOrig[x][y][z] = unitBlocksOrig[unitOrig[x][y][z]]
					unitOrig[x][y][z].hp = 0
					if unitOrig[x][y][z].density ~= nil then   --need this NOT to happen
						unitOrig[x][y][z].hp = unitOrig[x][y][z].density
					end
					if unitOrig[x][y][z].blastRes ~= nil then
						unitOrig[x][y][z].hp = unitOrig[x][y][z].hp + unitOrig[x][y][z].blastRes
					end
					--put unitOrig into unit[7][7][6]
					unit[x+1][y+1][z+1] = unitOrig[x][y][z]
				end
			end
		end
	end
	for z=1,5,1 do  --for every value of Z test if there are any blocks, if not, block above drops down (GRAVITY!)
		for x=1,5,1 do   --every value of X (I am so glad that I went for 5x5x5, not 10x10x10!)
			for y=1,5,1 do --every value of Y
				if unit[x][y][z] == nil then     --if there's no block in that place
					if testFloat(x,y,z,unit) == 0 then   --if not sticky or floating then
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
Unit.move(x,y,unit) -- returns 1 if unit can be moved and is moved successfully !LOCAL!
# Unit.rotate(x,y,degrees) -- checks for ownership, sentience and if the unit CAN move (power > friction, ignored if centre block), and then rotates it by degrees (only multiples of 90 are valid). LOCAL FUNCTION FOR TESTING WITH.
Unit.Update() -- works out where the electricity is going in the block
Unit.on(x,y,blockX,blockY) -- checks for ownership, if the block (blockX,blockY) has a CPU val
Unit.off(x,y,blockX,blockY) -- opposite of Unit.on.
Unit.pulse(x,y,blockX,blockY) -- a single pulse
Unit.sense(x,y,blockX,blockY) -- if sentient, returns 0 if unpowered or 1 if powered.
]]--


function Unit.sense(fieldX,fieldY,x,y,z)
	if field[fieldX][fieldY][x][y][z].cpu ~= nil then
		if field[fieldX][fieldY][x][y][z].powered ~= nil then
			return 1
		else
			return 0
		end
	end
end

function Unit.on(fieldX,fieldY,x,y,z)
	if field[fieldX][fieldY][x][y][z].cpu ~= nil then
		if field[fieldX][fieldY][x][y][z].cpu > 1 then
			field[fieldX][fieldY][x][y][z].power = 4
		end
	end
end

function Unit.off(fieldX,fieldY,x,y,z)
	if field[fieldX][fieldY][x][y][z].cpu ~= nil then
		if field[fieldX][fieldY][x][y][z].cpu > 1 then
			field[fieldX][fieldY][x][y][z].power = nil
		end
	end
end

function Unit.pulse(fieldX,fieldY,x,y,z)
	if field[fieldX][fieldY][x][y][z].cpu ~= nil then
		if field[fieldX][fieldY][x][y][z].cpu > 1 then
			field[fieldX][fieldY][x][y][z].power = 4
			table.insert(offit,{fieldX,fieldY,x,y,z})
		end
	end
end

local function pulseCheck()
	for i=1,#offit,1 do
		field[offit[1][1]][offit[1][2]][offit[1][3]][offit[1][4]][offit[1][5]].power = nil
	end
end

function Unit.update()   --run after each TURN!
	testElectricity()
	for fieldX=1,8,1 do
		for fieldY=1,8,1 do 
			for x=1,7,1 do
				for y=1,7,1 do
					for z=1,6,1 do
						if field[fieldX][fieldY][x][y][z].force ~= nil and field[fieldX][fieldY][x][y][z].isPowered == true then
							local testDir = {x,y}
							dir = findDir(testDir)
							if dir ~= nil then move(fieldX,fieldY,dir) end   --needs rotation!!!
							dir = nil
						end
					end
				end
			end
		end
	end   --not the end yet! do explosive testing
	testExplosives()
end

local function testExplosives()
	for fieldX=1,8,1 do
		for fieldY=1,8,1 do
			if field[fieldX][fieldY] ~= nil then
				for x=1,8,1 do
					for y=1,8,1 do
						for z=1,8,1 do
							if field[fieldX][fieldY][x][y][z].explosive ~= nil then
								for a=1,6,1 do
									local agree = false
									local x2 = x + test[a][1]
									local y2 = x + test[a][2]
									local z2 = z + test[a][3]
									if field[fieldX][fieldY][x2][y2][z2].powered ~= nil then
										agree = true
									end
								end
								if agree == true then
									--EXPLOSION!!!!
									explosion(fieldX,fieldY,x,y,z)
								end
							end
						end
					end
				end
			end
		end
	end
	if true then         --a totally useless line only there because I couldn't be bothered to untab all of those ends :P
		for fieldX=1,5,1 do
			for fieldY=1,5,1 do
				if field[fieldX][fieldY] ~= nil then
					for x=1,8,1 do
						for y=1,8,1 do
							for z=1,6,1 do
								if field[fieldX][fieldY][x][y][z].exploded ~= nil then
									local stick = 0
									local copy = field[fieldX][fieldY][x][y][z]
									local x2 = x
									local y2 = y
									local z2 = z
									local a = field[fieldX][fieldY][x][y][z].exploded
									for a=1,6,1 do
										local x2 = x + test[a][1]
										local y2 = x + test[a][2]
										local z2 = z + test[a][3]
										if field[fieldX][fieldY][x2][y2][z2].sticky ~= nil then
											stick = stick + field[fieldX][fieldY][x2][y2][z2].sticky
										end
									end
									if stick < field[fieldX][fieldY][x][y][z].explodedVal then
										while true do
											local x2 = x2 + a[1]
											local y2 = y2 + a[2]
											local z2 = z2 + a[3]
											local power = field[fieldX][fieldY][x][y][z].explodedVal
											if field[fieldX][fieldY][x2][y2][z2] == nil and power > 0 then
												field[fieldX][fieldY][x2][y2][z2] = copy
												local copy = field[fieldX][fieldY][x2][y2][z2]
												power = power - 1
											else
												explosion(fieldX,fieldY,x2,y2,z2)
												break
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	clearExplosion()
	pulseCheck()
end

local function explosion(fieldX,fieldY,x,y,z)
	for a=1,6,1 do
		local x2 = x + test[a][1]
		local y2 = y + test[a][2]
		local z2 = z + test[a][3]
		if x2 > 8 then
			x2 = x2 - 8
			fieldX = fieldX + 1
		elseif x2 < 1 then
			x2 = x2 + 8
			fieldX = fieldX - 1
		end
		if y2 > 8 then
			y2 = y2 - 8
			fieldY = fieldY + 1
		elseif y2 < 1 then
			y2 = y2 + 8
			fieldY = fieldY - 1
		end
		if z2 > 8 then z2 = 8 end
		if z2 < 1 then z2 = 1 end
		if field[fieldX][fieldY][x2][y2][z2] ~= nil then
			field[fieldX][fieldY][x2][y2][z2].exploded = test[a]
			field[fieldX][fieldY][x2][y2][z2].explodedVal = field[fieldX][fieldY][x][y][z].explosive
			calc(fieldX,fieldY,x,y,z)
		end
	end
	field[fieldX][fieldY][x][y][z] = nil
end

local function clearExplosion()
	for fieldX=1,8,1 do
		for fieldY=1,8,1 do
			for x=1,8,1 do
				for y=1,8,1 do
					for z=1,8,1 do
						field[fieldX][fieldY][x][y][z].exploded = nil
					end
				end
			end
		end
	end
end

local function testElectricity()
	local powerSources = { }
	for fieldX=1,8,1 do
		for fieldY=1,8,1 do
			if field[fieldX][fieldY] ~= nil then
				for x=1,7,1 do
					for y=1,7,1 do
						for z=1,6,1 do
							field[fieldX][fieldY][x][y][z].powered = nil
						end
					end
				end
			end
		end
	end
	while true do
		for fieldX=1,8,1 do
			for fieldY=1,8,1 do
				if field[fieldX][fieldY] ~= nil then
					for x=1,7,1 do
						for y=1,7,1 do
							for z=1,6,1 do
								if field[fieldX][fieldY][x][y][z].power ~= nil or field[fieldX][fieldY][x][y][z].powered ~= nil then
									for a=1,6,1 do
										local x2 = x + test[a][1]
										local y2 = x + test[a][2]
										local z2 = z + test[a][3]
										if field[fieldX][fieldY][x2][y2][z2].conductivity ~= nil then
											if field[fieldX][fieldY][x2][y2][z2].powered == nil then
												field[fieldX][fieldY][x2][y2][z2].powered = 2
												continue = true
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if continue ~= true then break end
	end
end

local function findDir(t)  --no Z!
	for i=1,8,1 do
		if t == up[i] then
			return up
		elseif t == down[i] then
			return down
		elseif t == left[i] then
			return left
		elseif t == right[i] then
			return right
		end
	end
	return 0
end

local function move(x,y,temp)    --used to calculate if a block can move
	local friction = 0
	local force = 0
	for xT=1,5,1 do
		for yT=1,5,1 do
			if testFloat(xT,xY,1,field[x][y]) == 0 then
				for zT=1,5,1 do
					friction = unit[xT][yT][zT].density + friction
				end
			end
		end
	end
	local rbs = { }   --stores all fuel blocks
	for f=1,8,1 do
		local fBlock = unit[temp[f][1]][temp[f][2]].force  --force of block on side
		if fBlock ~= nil then
			force = force + fBlock    --calculate total force from side <dir>
			table.insert(rbs,temp[f])
		end
	end
	if force < friction then
		return 0
	else
		local dif = force - friction
		local b = 1 --counter
		while true do   --PAYMENT!
			local i = rbs[b][1]
			local j = rbs[b][2]
			if unit[i][j].force >= dif then
				unit[i][j].force = unit[i][j].force - dif   --pay with reduction of force
				break                          --if four force is required, four is payed for
			else
				dif = dif - unit[i][j].force
			end
		end
		return 1
	end
end

local function testFloat(x,y,z,unit)
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
	for zT=1,6,1 do
		if unit[x+1][y][z].sticky ~= nil then sticky = 1
		elseif unit[x-1][y][z].sticky ~= nil then sticky = 1
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

local function calc(fieldX,fieldY,x,y,z)
	field[fieldX][fieldY][x][y][z].hp = field[fieldX][fieldY][x][y][z].hp - field[fieldX][fieldY][x][y][z].explodedVal
	if field[fieldX][fieldY][x][y][z].hp < 1 then field[fieldX][fieldY][x][y][z] = nil end
end
