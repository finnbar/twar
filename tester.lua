--[[
	This is a file that I am using for testing. It builds and deploys (on 3,2) a unit consisting of a cpu block next to an explosive and explosion-resistant block. The test should end with the third block being propelled away after using --> Unit:on(3,2,4,3,1), which turns on the cpu block. If this is successful, then more commands will be added to this.
]]--

require("chem")

--function that prints values
function thisIsIt(message)
	print(message)
	toPrints = {}
	for fX=1,8,1 do
		for fY=1,8,1 do
			if instanceOf(Build,field[fX][fY]) then
				print(fX,fY,"contains:")
				for z=1,7,1 do
					print("layer" .. z .. ":")
					for y=1,8,1 do
						for x=1,8,1 do
							if instanceOf(Chem,field[fX][fY][x][y][z]) then
								table.insert(toPrints,field[fX][fY][x][y][z])
							else table.insert(toPrints,"00000") end
						end
						print(toPrints[1],toPrints[2],toPrints[3],toPrints[4],toPrints[5],toPrints[6],toPrints[7],toPrints[8])
					end
				end
			end
		end
	end
end

Unit:init()   --will be run by system on startup :P
a=Chem:create("Si Si H H H")
b=Chem:create("N N N H H H H")
c=Chem:create("Fe Fe Fe H H H H H")  --creates three different blocks
Build:placeBlock(1,1,1,c)
Build:placeBlock(3,2,2,a)
Build:placeBlock(3,3,2,b)
Build:placeBlock(3,4,2,c)  --places them in position
r = Build:make()    --turns them into a unit
Unit:deploy(r,1)    --puts unit on field.
thisIsIt("before the before :P")
Unit:on(3,2,4,3,1)
thisIsIt("before /n /n")
Unit:update()
thisIsIt("after /n /n")