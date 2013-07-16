local building = {{{},{},{},{},{}},{{},{},{},{},{}},{{},{},{},{},{}},{{},{},{},{},{}},{{},{},{},{},{}}}  --a 5x5x5 array
build = { }
build.__index = build
user = { }     --may be moved to user.lua, which will mainly hold tweets (user-created functions) and stats
user.__index = user    --thought: always truncate energy after command?
user.energy = 9000   --TEMPORARY!

function build.placeBlock(x,y,z,block)  --obvious arguments
  if x ~= nil then	  --bonus: use nil for x then it won't do anything except return 1 for "this block COULD be placed" and 0 for "no energy, suckah!"
		if user.energy >= block.energy then
			building[x][y][z] = block
			user.energy = user.energy - block.energy
			return 1
		else return 0 end
	else if user.energy >= block.energy then return 1 else return 0 end
end
end

function build.rmBlock(x,y,z,block)  --obvious arguments. Removes block and returns 50% energy. Woot!
	if building[x][y][z] == block then
		building[x][y][z] = nil
		local en = block.energy/2
		user.energy = user.energy + en
		return 1
	else return 0 end
end

function build.suspen(x,y,z,block)  --obvious args. builds a suspension block, which is 1/4 of the size, takes 1/4 of the energy but has 1/4 of the stats...
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

function build.make()   --release the building into the field! yaaaayyy!	
	local unit = {{{},{},{},{},{}},{{},{},{},{},{}},{{},{},{},{},{}},{{},{},{},{},{}},{{},{},{},{},{}}}
	local unitBlocks = { }
	local assigned = false
	unitBlocks[1] = building[1][1][1]   --SOMETHING IS GOING WRONG. unitBlocks[a][b] has nil
	for x=1,5,1 do     --for every value of x
		for y=1,5,1 do   --of y
			for z=1,5,1 do --of z do
				for q=1,#unitBlocks,1 do    --for each known block (for this UNIT)
					if unitBlocks[q] == building[x][y][z] then   --check if it's the same block
						if unitBlocks[q].density == building[x][y][z].density then
							unit[x][y][z] = q    --it's the same, link to it
							assigned = true
						end
					end
				end
				if assigned == false then
					unitBlocks[#unitBlocks + 1] = building[x][y][z]
					unit[x][y][z] = #unitBlocks   --not the same, create a new entry for it
				end
				assigned = false   --RESET!
			end
		end
	end  --you've checked every value now
	for z=1,5,1 do  --for every value of Z test if there are any blocks, if not, block above drops down (GRAVITY!)
		for x=1,5,1 do   --every value of X (I am so glad that I went for 5x5x5, not 10x10x10!)
			for y=1,5,1 do --every value of Y
				if unit[x][y][z] == nil then
					local copy = unit[x][y][z+1]  --cut the block above
					unit[x][y][z+1] = nil   --down one level
					unit[x][y][z] =	copy    --and paste
				end
			end
		end
	end --DO ALL THE METATABLE JAZZ (yay! jazz!!) <- NOTE: NO METATABLE JAZZ REQUIRED YET. AWW.
	build.clear(0)
	return unit, unitBlocks  --requires BOTH
end  --hint: want to find out a stat? run unitBlocks[blockNum].stat
--or even unitBlocks[unit[x][y][z]].stat for ultimate control.
--STILL NEEDS TO BE READ-ONLY!!!

function build.read(x,y,z)    --forcing it to read, but making it unable to write, building[x][y][z]!
	return building[x][y][z]
end

function build.readAll()
	return building
end

function build.clear(restore)  --when called w/ restore == 1, restores 50% energy. if called with restore == 0 (when used by build.make()), it doesn't restore
	for x=1,5,1 do
		for y=1,5,1 do
			for z=1,5,1 do
				if building[x][y][z] ~= nil then
					local en = building[x][y][z].energy/2
					building[x][y][z] = nil
					if restore == 1 then
						user.energy = user.energy + en
					end
				end
			end
		end
	end
end
