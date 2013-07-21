require "server"   --currently non-existent
User = { }

function User.name()
	return server.get("user")
end

function User.energy()
	return server.get("energy")
end

function User.energyC(val)   --energy CHANGE. needs to only be callable by non-user code
	local energy = server.get("energy")
	energy = energy + val
	server.send("energy",energy)
	return energy
end

function User.awesome()   --rank
	return server.get("rank")
end

function User.awesomeC(val)   --needs to only be callable by non-user code
	local rank = server.get("rank")
	rank = rank + val
	server.send("rank",rank)
	return rank
end

function User.elementsC(new)
	local elements = server.get("elements")
	table.insert(elements,new)
	server.send("elements",elements)
	return elements[#elements]
end

function User.elements()
	local elements = server.get("elements")
	return elements
end
