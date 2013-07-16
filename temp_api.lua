--[[This is an API that contains both created and uncreated code, as to show what I want to achieve with this cool project :)
I will list these as if they were a collection of Tweets, with ((--Tweet X)) as an identifier of this.
This is pretty ambitious, to say the least.
Each tweet will have a mulit-line comment to signal what it requires to run.
So yeah, this is cool! (MODESTY INTENDED)  ]]--

--[[ TWEET1: creates a block with id water, and lays out all its properties (e.g. density). COMPLETED! Note for the unbelievers: this is 139 chars long! (ignoring comment). However, that treats a TAB as many chars, so it's OK!]]--

water = Chem.create("H H O")
user.elements.add(water)    --adds water to the user's bank of elements. INCOMPLETE.
a = user.elements[math.random(#user.elements)].density  --the density val of a random entity in user.elements[]
if a < 1 then
  print(a)
end

--[[ TWEET2: places "water" and another Chem.create("U H H") in random formation in the build area. COMPLETED!
Also: in these examples, we assume that "water" has been carried over. Unimplemented idea: hashtags are global variables that CAN be changed by someone else. Saboutage time! So in this case, it was #water, not water, which brings char count to 141... (not including TAB dedution) idea two: hashtags only need to be declared once, e.g. in TWEET1, #water on the first line and water on the second...]]--

uhh = Chem.create("U H H")
for x=1,5,1 do      --for every value of x
	for y=1,5,1 do    --of y
		for z=1,5,1 do  --of z do
			a = math.random(2)
			if a==1 then build.placeBlock(x,y,z,water)  --x,y,z,block
			else build.placeBlock(x,y,z,uhh)            --build area is 5x5x5
			end
		end
	end
end

--Way too many chars over... there's a better way to do this, isn't there? YES THERE IS!

--[[ TWEETS2&3: a second attempt at Tweet 2, using functions (but one extra Tweet) COMPLETED!
This is stupidly useful. Please remember this example.
A note: in each of these examples, I use user.x. This should be the user's name, so in my current case, terrabyte_aura.x.]]--

function user.randomPlace2(x,y,z,block1,block2,rand)   --x,y,z, two blocks and a random number
	if rand==1 then build.placeBlock(x,y,z,block1)
	else build.placeBlock(x,y,z,block2) end
end

for x=1,5,1 do
	for y=1,5,1 do
		for z=1,5,1 do
			user.randomPlace2(x,y,z,water,Chem.create("U H H"),math.random(2))
		end
	end
end

--[[ TWEETS4&5: checking if I have enough energy to place these blocks, and if I don't, I wait until I do. user.energy is not 100% implemented yet ]]--

function user.energyGood(username,comp)    --username and a value to compare to
	if username.energy > comp then return 1 else return 0 end  --is user.energy greater than the comparison? you know what to do!
end

for i=1,5,1 do
	if build.placeBlock(i,1,1,water) == 0 then
		while user.energyGood(user,water.energy) == 0 do end
	end
end

--[[ TWEET6: Very simple stuff, just showing how to make yo' unit, good people! Fully implemented! ]]--

unit, unitBlocks = build.make()   --SUPER IMPORTANT TO USE TWO VARIABLES. IF YOU DON'T, YOU LOSE YOUR UNIT AND ALL THE ENERGY THAT IT COSTED TO MAKE IT! GOSH DARN IT!


--[[ TWEETS7&8: An interesting example that suggests a lock method for when leaving a unit (until unlocked), it monitors the build[] and, if any changes occur while it's locked, it will attempt to fix them. Cannot Tweet while locked. In fact, the previous code is immediatly stopped upon Tweeting. Technically implemented!]]--

function user.lock(backup,blocks)  --backup building, and a table of blocks to replace bits with.
	while true do
		if backup ~= build.readAll() then  --then PANIC! ('cause they're different)
			for x=1,5,1 do for y=1,5,1 do for z=1,5,1 do  --FOR EVERY BLOCK (as soon as I find out how to shorten this my life will be complete)
				if backup[x][y][z] == nil and build.read(x,y,z) ~= nil then  --if new block added
					for i=1,#blocks,1 do
						if build.rmBlock(x,y,z,blocks[i]) == 1 then break end  --find out which block it is, and remove it (as you need a block type to do this)
					end
				elseif backup[x][y][z] ~= nil and build.read(x,y,z) == nil then --block REMOVED :(
					for i=1,#blocks,1 do
						if backup[x][y][z] == blocks[i] then place = blocks[i] break end
					end
					build.placeBlock(x,y,z,place)   --replace it
				end
			end
		end
	end
end  --this will NEVER fit into a tweet without serious function making. Which I can't be bothered to do right now.

--another tweet
user.lock(build.readAll(), user.elements)  --for everything that we know (the entire building and all of the user's known elements)

--[[ TWEET9: Actually using the units. Not even started yet. Will do!
The idea of this (which will be in unit.lua) is to work out a few things about the units, and give them powers based on that, such as control
Note: as these next functions are nowhere NEAR implemented, these provide a very basic idea of how to use them.]]--

robot = unit.load(unit,unitBlocks,x,y)  --takes in unit and blocks, along with starting position
print(robot.sentient)  --if a unit is sentient, it can receive all other unit commands. Sentience is achieved with at least one block with block.cpu > 2. To move, a unit must be floating (so the bottom of the unit is covered in Helium), which is considered to be true if unit.float > unit.density. Also, a computer will only be functional if powered (I think that there will be an element (maybe Zinc?) that does this), and can be anywhere on the robot as long as there is a trail of blocks with conductivity between the battery and computer.
robot.power("ON",blockX,blockY,blockZ,side)  --powers something. wants state (power "ON", power "OFF" or power "BURST" (a single jolt of power, useful for triggering explosives :D ), x,y,z of the computer, and what side it should power
panic = robot.isPower(blockX,blockY,blockZ)  --x,y,z of block that you're querying. Blocks with block.cpu == 1 can do this? maybe use unit.sensor = true (when cpu==1)

--[[ OK, so there's my thoughts. Most of this is already implemented, which is cool! Let's summarise:

Units are made out of blocks in build.x
Blocks are made out of atoms with Chem.build
And now a new point:
STICKY BLOCKS!

Now, as you probably don't know, because I haven't mentioned it yet, the element U (Uranium) is sticky as well as radioactive, which means that it can stick to other blocks (as you may have guessed). This means that you can combine units and use them to your own mischief! You could have a floating helium tank (which fires explosives towards another unit with explosions triggered by a computer) attached to two jetpacks either side to move it! (jetpacks made out of iron (super blast resistance) with some sort of fuel (such as carbon) that is burned to produce flames and propel it! gosh this is gonna be difficult...  ]]--
