function highscore_new(filename, places, name, score)
	local file=love.filesystem.newFile(filename)
	file:open("w")
	local a=1
	for a=1, places do
		file:write(name.."\n"..score.."\n")
	end
	file:close()
end

function highscore_load(filename)
	local file=love.filesystem.newFile(filename)
	file:open("r")
	local a=1
	local stringtype=1
	highscore_name={}
	highscore={}
	for line in file:lines() do
		if stringtype==1 then
			highscore_name[a]=line
			stringtype=2
		else
			highscore[a]=tonumber(line)
			stringtype=1
			a=a+1
		end
	end
	highscore_places=a-1
	file:close()
end

function highscore_write(filename)
	local file=love.filesystem.newFile(filename)
	file:open("w")
	local a=1
	for a=1, highscore_places do
		file:write(highscore_name[a].."\n"..highscore[a].."\n")
		a=a+1
	end
	file:close()
end

function highscore_add(score, name)
	local a=1
	for a=1, highscore_places do
		if score>highscore[a] then
			local b=highscore_places
			for b=highscore_places, a+1, -1 do
				highscore_name[b]=highscore_name[b-1]
				highscore[b]=highscore[b-1]
			end
			highscore[a]=score
			highscore_name[a]=name
			break
		end
	end
end