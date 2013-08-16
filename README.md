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

IMPLEMENTED BUT UNTESTED:

<code>Unit:off(x,y,blockX,blockY,side)        --pretty obvious.</code>
<code>Unit:sense(x,y,blockX,blockY,side)      --returns 0 if no electricity present, else returns 1.</code>

AND COMING SOON... ISH... MAYBE...

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

    l.fun a()
      build:placeBlock(1,1,1,block)
    end

then you could use it as your own with:

    for x=1,5,1 do
      t_a.a()
    end

allowing you to steal your opponent's good code!

future features (after v0.1)
===

<ul>
<li> Implementation of multiple languages, such as Ruby, Javascript and <a href=https://en.wikipedia.org/wiki/Malbolge>Malbolge</a>, for example: </li>
</ul>

    j.v addBlock = j.fun(var thing = 0) {   //each language is declared with <name.>, e.g j. (javascript), r. (ruby), mal. (malbolge), l. (lua), p. (python?)
      r.i thing == 0   #it has to be done even in the case of r.i being LONGER than "if"
        l.print(mal.run(str))  -- look, another lang, another line! as malbolge is VERY LIMITED, it only needs mal.run(). You CANNOT put more than one lang per line, except in the case of using mal.run()
      j.}  //yes, you can end logic in another lang. it's all converted to Lua anyway.
    }      //the converter will basically remove brackets in the if statement's arguments, and then convert "}" or whatever to "end"
    
This allows for some very evil obsufication, particularly with Malbolge!

    str = <malbolge that returns "Build:clear(0)">
    l.fun freeStuff()
      thing = l.loadString(mal.run(str))
      thing()
    end

You could trick the opponent into running the code and deleting their build!
I'm so evil!
And really stupid for trying to implement such crazy ideas :P

<ul>
<li> A GUI. No, seriously, that comes before everything else. </li>
<li> An inventory, and the ability to remove units from the field. </li>
<li> MORE HACKING METHODS! Rather than just trying to get your opponent to Build:clear(0), better methods such as passwords and public keys. Maybe:</li>
</ul>

    --each person has a PUBKEY
    t_a.pub = "wefhoiwefnwe98238012"
    --and a PRIVKEY
    t_a.priv = "fwihowioncoi328iwedn"
    --THESE ARE JUST EXAMPLES, don't be stealing my stuff!
    --So, you can run code as other people with the command User:runAs(pub,priv)
    pub=t_a.pub
    priv=t_a.priv
    User:runAs(pub,priv)
      <awesome code>
    end
 
<ul>   
<li>To try and get a privkey, maybe you can intercept parts of a key with computers placed near the enemy's castle? For each cpu level (silicon atom), you get one part of the key, up to a maximum of four per block.</li>


<li> Make the arena higher, so that you can have bots that fly over others and throw bombs at them! </li>
</ul>

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
