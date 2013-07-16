-- [[ converts Tweets into executable Lua code :) ]] --

local assigns = nil
local k = 1
local temp = nil
local go = 0
local rA = nil
local rB = nil
local var = nil
local val = nil
local pass = nil
local fail = nil
--all variables below = temp
user = { }
user.name = "t_a"
t_a = { }

io.write("Please type tweet...   ")
tweet = io.read()
tweet = string.gsub(tweet,"l.fun","function")    --lengthens all shortened thingies
tweet = string.gsub(tweet,"l.i","if")    --if anyone uses this then they are silly
tweet = string.gsub(tweet,"l.f","for")   --not gonna do "in, or "do" as they are short anyway... quite silly to use this one, but hey, it has no negative effect!
tweet = string.gsub(tweet,"l.e","else")
tweet = string.gsub(tweet,"l.w","while")
tweet = string.gsub(tweet,"l.t","then")
tweet = string.gsub(tweet,"l.l","local")
tweet = string.gsub(tweet,"##","~")  -- ## = # (for number of elements in a table), this is a temporary conversion so that they don't get removed in the next blocks

--var == var2 is now tG(var) == tG(var2)
while true do
  rA,rB = string.find(tweet,"(%s+)#(%S+)(%s*)==(%s*)(%S+)(%s+)")
	if rA ~= nil and rB ~= nil then
		local vari,varia,finder,assigner = nil,nil,nil,nil
		assigner = string.sub(tweet,rA + 1,rB)
		rA,rB = string.find(assigner,"(%s+)#(%S+)(%s*)==")
		varia = string.sub(assigner,rA+1,rB-2)
		rA,rB = string.find(varia,"#(%w+)")
		finder = string.sub(varia,rA,rB)
		rA,rB = string.find(varia,"(%w+)")
		vari = string.sub(assigner,rA,rB)
		tweet = string.gsub(tweet,finder," tG(" .. vari .. ") ")
		rA,rB = nil,nil
	else break end
end

pass = string.find(tweet,"for(%s)(%S+)(%s*)=(%s*)(%S+)(%s)")
fail = string.find(tweet,"(%s)(%S+)(%s*)=(%s*)(%S+)(%s)")   --if no hashtag is used, fail.
if fail ~= nil and pass == nil then return 0 end    --UNLESS the no hashtag is in a FOR loop
pass,fail = nil,nil
--this next block takes #val = var and converts it into tV(val,var) (which sends it to the server)
while true do
	rA,rB = string.find(tweet,"#(%S+)(%s*)=(%s*)(%S+)(%s)")
	if rA ~= nil and rB ~= nil then
		assigns = string.sub(tweet,rA,rB)   --returns the first assignment as "#var = val"
		for a in string.gmatch(assigns,"#(%S+)") do
			var = a
		end
		for a,b in string.gmatch(assigns,"=(%s*)(%S+)") do
			val = b
		end
		tweet = string.gsub(tweet,assigns,"tA(" .. var .. "," .. val .. ") ")  --assigns and updates
		rA,rB = nil,nil
	else break end
end
--need to write something for getting vals! also, test

tweet = string.gsub(tweet,"~","#")   --makes ## into # (elements in a table)
for a in string.gmatch(tweet,"function") do
	if a ~= nil then go = 1 else go = 0 end
end
if go == 0 then
	temp = loadstring(tweet)
	temp()          --one off execution
else
	for a in string.gmatch(tweet,"function (%w+)") do
		funName = a    --what's the function name?
	end
	tweet = string.gsub(tweet,"function (%w+)", "function " .. user.name .. "." .. funName)
	--tweet = string.gsub(tweet,"function ([_%.%w]+)","")  If you want to remove the "function user.x" part of the tweet, uncomment
	temp = loadstring(tweet)
	if temp ~= nil then temp() else print("FAIL") end
	print(tweet)
end

function tV(var)   --"take value"
	--write var to server
	return var
end
