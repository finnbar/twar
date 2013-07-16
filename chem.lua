Chem = { }
Chem.__index = Chem
energy = 0
chemp = 0
H = 1    --atom energies. Will grow, I promise. WILL BE READ-ONLY
Fe = 3
He = 2
Cu = 4
Si = 5
U = 7
N = 3

--HOW IT WORKS: block = Chem.create(formula) where formula is a string of elements, eg "Fe H U H"
function Chem.create(formula)  --PROBLEM: com.x can be changed with normal usage (e.g. com.x = 9000), needs read-only or check per frame
  local com = { }
	local q = 1
	local chempound = { }
	for i in string.gmatch(formula, "%S+") do
		chempound[q] = i  --extract elements (so "Fe H Fe" becomes {Fe,H,Fe})
		q = q + 1
	end
	setmetatable(com,Chem)
	com.formula = formula
	for i=1,#chempound,1 do   --decide properties
		if chempound[i] == "H" then com.density = decider(com.density) end
		if chempound[i] == "Fe" then com.blastRes = decider(com.blastRes) end
		if chempound[i] == "He" then com.float = decider(com.float) end
		if chempound[i] == "Cu" then com.conductivity = decider(com.conductivity) end
		if chempound[i] == "Si" then com.cpu = decider(com.cpu) end
		if chempound[i] == "U" then
			com.radioactive = decider(com.radioactive)
			com.sticky = decider(com.sticky)
		end
		if chempound[i] == "N" then com.explosive = decider(com.explosive) end
		--many more properties go here, e.g. regeneration, electricity, useTool (for repairs)
		decider(com.total)  --add to total value
		chemp = _G[chempound[i]]   --takes the global variable that chem is
		if chemp == nil then chemp = 0 end
		energy = energy + chemp   --makes com.energy, the required amount of energy needed to place this block
	end
	if com.density == nil then com.density = 0 end
	if com.total == nil then com.total = 0 end
	local total = com.total - com.density
	com.energy = energy
	if total > com.density then com.unstable = true else com.unstable = false end  --stops over-powering of blocks. an unstable block may collapse on placement or transfer
	return com   --return created class
end

function decider(w)  --"increases" com.x by 1
	if w == nil then w = 1
	else w = w + 1 end
	return w
end
