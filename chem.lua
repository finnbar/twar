energy = 0
chemp = 0
H = 1    --atom energies. Will grow, I promise. WILL BE READ-ONLY
Fe = 3
He = 2
Cu = 4
Si = 5
U = 7
N = 3
Rb = 3
Pb = 4
Sn = 2

require "requirer"

--HOW IT WORKS: block = Chem.create(formula) where formula is a string of elements, eg "Fe H U H"
Chem = class("Chem")
function Chem:create(formula)  --PROBLEM: self.x can be changed with normal usage (e.g. self.x = 9000), needs read-only or check per frame
	self = Chem:new()
	self.energy = 0
	local q = 1
	local chempound = { }
	for i in string.gmatch(formula, "%S+") do
		chempound[q] = i  --extract elements (so "Fe H Fe" becomes {Fe,H,Fe})
		q = q + 1
	end
	self.formula = formula
	self.hp = 0
	for i=1,#chempound,1 do   --decide properties
		if chempound[i] == "H" then self.density = decider(self.density) end
		if chempound[i] == "Fe" then self.blastRes = decider(self.blastRes) end
		if chempound[i] == "He" then self.float = decider(self.float) end
		if chempound[i] == "Cu" then self.conductivity = decider(self.conductivity) end
		if chempound[i] == "Si" then self.cpu = decider(self.cpu) end
		if chempound[i] == "U" then
			self.radioactive = decider(self.radioactive)
			self.sticky = decider(self.sticky)
		end
		if chempound[i] == "Rb" then self.force = decider(self.force) end
		if chempound[i] == "N" then self.explosive = decider(self.explosive) end
		--many more properties go here, e.g. regeneration, electricity, useTool (for repairs)
		decider(self.total)  --add to total value
		chemp = _G[chempound[i]]   --takes the global variable that chem is
		if chemp == nil then chemp = 0 end
		self.energy = self.energy + chemp   --makes self.energy, the required amount of energy needed to place this block
	end
	if self.density == nil then self.density = 0 end
	if self.total == nil then self.total = 0 end
	local total = self.total - self.density
	if self.density == self.float then total = 0 end
	if total > self.density then self.unstable = true else self.unstable = false end  --stops over-powering of blocks. an unstable block may collapse on placement or transfer
	return self   --return created class
end

function decider(w)  --"increases" self.x by 1
	if w == nil then w = 1
	else w = w + 1 end
	return w
end
