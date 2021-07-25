function start (song)
	print("Prepare to get ur ass blasted boi")
end


function update (elapsed) -- example https://twitter.com/KadeDeveloper/status/1382178179184422918
	if curStep >= 1152 and curStep < 1664 then
		local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 20 * math.sin((currentBeat + i*0.25) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.25) * math.pi), i)
		end
	else
        	for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'],i)
			setActorY(_G['defaultStrum'..i..'Y'],i)
        end
	end
end

   

function beatHit (beat)
	if curStep >= 1150 and curStep < 1408 then
		setCamZoom(1)
		setHudZoom(1.5)
	end
	if curStep >= 1536 and curStep < 1664 then
		setCamZoom(1)
		setHudZoom(1.5)
	end
end

function stepHit (step)
	spincenter = true
    if curStep >= 1536 and curStep < 1663 then
	    for i=0,3 do
		    tweenPosXAngle(i, _G['defaultStrum'..i..'X'] + 360, getActorAngle(i) + 360, 0.6, 'setDefault')
		    setActorY(_G['defaultStrum'..i..'Y'],i)
	    end
	    for i=4,7 do
		    tweenPosXAngle(i, _G['defaultStrum'..i..'X'] + 275, getActorAngle(i) - 360, 0.6, 'setDefault')
		    setActorY(_G['defaultStrum'..i..'Y'],i)
	    end
	end
	if curStep == 1664 then
		for i=0,7 do
			setActorAngle(0, i)
		end
	if curStep >= 1655 and curStep < 1663 then
		camHudAngle = camHudAngle + 7
	    end
	if curStep == 1663 then
		camHudAngle = 0
        end	
	end
end

function keyPressed (key)
   -- do nothing
end

