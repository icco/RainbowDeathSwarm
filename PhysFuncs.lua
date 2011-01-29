-- physics functions for lua

--called when two objects first touch
function Cadd(obj1, obj2, Ccontact)
	if (obj1.body:getY() >= obj2.body:getY()) then
		local norx, nory = Ccontact:getNormal()
		if math.cos(norx/nory) < 0 then
			obj1:isTouching = true
		end
	elseif obj1.body:getY() < obj2.body:getY() then
		local norx, nory = Ccontact:getNormal()
                if math.cos(norx/nory) > 0 then
                        obj2:isTouching = true
                end
	end
end

--called when two objects are touching
function Cpersist(obj1, obj2, Ccontact)
end

--called when two objects are leaving
-- TODO possible bug alert, Object may be touched by two objects above. 
function Cremove(obj1, obj2, Ccontact)
 if (obj1.body:getY() >= obj2.body:getY()) then
		obj1:isTouching = false 
        elseif obj1.body:getY() < obj2.body:getY() then
		obj2:isTouching = false 
        end
	
end
