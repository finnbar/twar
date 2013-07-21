--[[ MOST OF THIS IS JUST TEMPORARY, OK? ]]--

server = { }
--temporary from below. will be replaced with actual server collection (through LOVE or Polycode)
elements = { }
rank = 1
energy = 4000
name = "terrabyte_aura"

function server.get(cat)  --short for category
	if cat == "elements" then
		--get elements
		return elements
	elseif cat == "rank" then
		--get rank
		return rank
	elseif cat == "energy" then
		--get energy
		return energy
	elseif cat == "name" then
		--get name w/ Twitter APT
		return name
	end
end

function server.send(cat,val)   --if there's some way to check then do that too
	if cat == "elements" then
		elements = val
		--send elements. send requires: category,value,username
		return 1
	elseif cat == "rank" then
		rank = val
		--send rank
		return 1
	elseif cat == "energy" then
		energy = val
		--send elements
		return 1
	end
end
