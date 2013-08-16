twar
====

twar - a game where you code on twitter in lua to synthesise blocks, build and conquer!

api
===

There is a file called temp_api.lua which gives examples of how the code works and what I need to do (which is a *lot*). temp_api is OUT OF DATE!!! IGNORE IT FOR NOW.

A couple of notes: in a recent commit, naming conventions were changed from function.sub() to Function:sub(), which allows me to look out for cheaters! Grr, cheaters!

Each "Function" is now its own class, so Chem:create() produces instances of the Chem class, which is checked for by Build (which creates instances of Build:new()). Unit doesn't need this as a unit is a build plus some space (although I may implement it anyway :P).

But here's some quick examples of what is done:

<code>block = Chem:create("Fe H U Rb")        --create a block using these elements</code>
<code>build:placeBlock(x,y,z,block)           --place that block in the workspace</code>
<code>build:read(x,y,z)                       --what is the block in x,y,z?</code>
<code>unit = build:make()                     --turn the array of blocks into a moveable "unit"</code>
<code>Unit:deploy(unit,unitBlocks,spawnPoint) --place the new "unit" on the field. Now actually works!</code>
<code>Unit:on(x,y,blockX,blockY,side)         --power on blockX,blockY within field x,y on side "side"</code>

AND COMING SOON... ISH... MAYBE...

<code>Unit:off(x,y,blockX,blockY,side)        --pretty obvious. Implemented but untested</code>
<code>Unit:sense(x,y,blockX,blockY,side)      --returns 0 if no electricity present, else returns 1. Implemented but untested.</code>

<code>twar:declare(@user)                     --declares (t)war on @user</code>
<code>twar:conditions(conditions)             --sets conditions, e.g. energy limit</code>

So yeah.
The actual idea of twar is to destroy your opponents "castle" (name in progress), by using units. These units can saboutage other units and damage the castle in a variety of ways:
<ul>
<li>Damage them with explosive blocks (which explode on contact with another unit or when electricity is next to it)</li>
<li>Fling heavy blocks (with explosives) to weigh down units and prevent them from moving</li>
<li>Fling electrical blocks to cause explosives to pre-detonate</li>
<li>Block the way (with super heavy units).</li>
<li>Stick units together to create larger units with massive mechanisms (such as jetpacks made of multiple Rb blocks).</li>
</ul>

Each unit is made of blocks, which are made with atoms, each with their own properties (list unfinished):
<ul>
<li>H & Pb: Density, for super heavy blocks but also stablility (as blocks cannot be made without H)</li>
<li>Fe: Blast Resistance, for resisting blasts I guess!</li>
<li>N: Explosive, for BLOWING STUFF UP MOTHER FLUFFER.</li>
<li>U: Radioactive and sticky, for joining units, but possibly making them unstable in the process.</li>
<li>Cu: Conductivity, for conducting the electricity from the computer around the unit.</li>
<li>Si: CPU/Sentience (needs a name), which allows units to be controlled, and acts as a power source.</li>
<li>Sn: Destructible, can be easily destroyed with electricity, which is useful for setting off explosives when hit.</li>
<li>Rb: Force, provides force outwards when electricity (heat) is applied, for actually moving units.</li>
</ul>

These blocks, when joined together, can do amazing things and stuff like that, in order to help you win the (t)war!

However, there is one extra feature that you may want to know about: shortenings. To make it possible to tweet this code, there are new shortenings, such as l.fun (which is equal to function (in Lua)). I'm hoping to be able to add more languages in the future.

You can also steal other people's tweets for your code. Everyone's tweet is a useable function, for example, if I tweeted:

<code>l.fun a() build:placeBlock(1,1,1,block) end"</code>

then you could use it as your own with:

<code>
for x=1,5,1 do
  t_a.a()
end
</code>

allowing you to steal your opponent's good code!

naq
===
(never asked questions as nobody has asked me anything yet)

Go to the GitHub pages site to find out about the inspiration and stuff!
http://finnbar.github.io/twar/

Also, go to ideasquish as it's cool! Also, it's got my original idea on there.
http://ideasquish.wordpress.com/2013/06/27/twitter-war-by-terrabyte_aura/

ALSO ALSO ALSO ALSO ALSO:
https://www.dropbox.com/s/9o6d9bmfl5y84ls/whiteboardDesign.jpg (design stuff)

thanks to
===

EVERYONE! Alright, maybe not everyone. But certainly:
<ul>
<li> Puzzlem00n, for dealing with my lack of Lua knowledge when we were creating <a href="http://allhailnoah.github.io/PonycornMusicDreamers/">"Song Of Sparks"</a> and showing me this great language!</li>
<li> Michcioperz, a pretty great guy!</li>
<li> iandioch, overally crazy game-making person that got me into the group as well as a formidable enemy in my first twar.</li>
<li> LOVE2D wiki.</li>
<li> THE LUA DOCS. Tim'll know why :P</li>
<li> And anyone else I've forgotten.</li>
</ul>

libraries used so far
===

Kikito's "middleclass": https://github.com/kikito/middleclass
(this library is awesome, use it!!!)
