-- physics functions for lua

--called when two objects first touch
function Cadd(obj1, obj2, Ccontact)
	if obj1 ~= nil and obj2 ~= nil and (obj1.body:getY() <= obj2.body:getY()) then
		local norx, nory = Ccontact:getNormal()
		if obj1.isTouching ~= nil then --math.cos(nory*1/(nory*nory+norx*norx)) < 0 then
			obj1.isTouching = true
		end
	elseif obj2 ~= nil and obj1 ~= nil and obj1.body:getY() > obj2.body:getY() then
		local norx, nory = Ccontact:getNormal()
                if obj2.isTouching ~= nil then --math.cos(nory*1/(nory*nory+norx*norx)) > 0 then
                        obj2.isTouching = true
                end
	elseif obj1 ~= nil then
		obj1.isTouching = true
	elseif obj2 ~= nil then
		obj2.isTouching = true
	end
end

--called when two objects are touching
function Cpersist(obj1, obj2, Ccontact)
	--	if obj1 ~= nil and obj1.isTouching ~= nil then obj1.isTouching = true end
	--	if obj2 ~= nil and obj2.isTouching ~= nil then obj2.isTouching = true end
end

--called when two objects are leaving
-- TODO possible bug alert, Object may be touched by two objects above. 
function Cremove(obj1, obj2, Ccontact)
 	if obj1 ~= nil and obj2 ~= nil and obj1.body:getY() <= obj2.body:getY() then
		obj1.isTouching = false 
        elseif obj2 ~= nil and obj1 ~= nil and obj1.body:getY() > obj2.body:getY() then
		obj2.isTouching = false 
	elseif obj1 ~= nil then
		obj1.isTouching = false
	elseif obj2 ~= nil then
		obj2.isTouching = false
        end
	
end

function Cresult()
end
