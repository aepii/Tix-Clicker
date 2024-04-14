local Handler = {}

Handler.Suffixes = {
	'k','M','B','T','qd','Qn','sx','Sp','O',
	'N','de','Ud','DD','tdD','qdD','QnD','sxD',
	'SpD','OcD','NvD','Vgn','UVg','DVg','TVg',
	'qtV','QnV','SeV','SPG','OVG','OVG','TGN','UTG',
	'DTG','tsTG','qtTG','QnTG','ssTG','SpTG','OcTG'
}

function Handler:Convert(value)
	for i = #Handler.Suffixes,1, -1 do
		if value >= 10 ^ (i * 3) then
			return string.format("%.14g",math.floor(value / 10 ^ ((i*3) - 2)) * 0.01) .. Handler.Suffixes[i]
		elseif value < 10 ^ 3 then
			return string.format("%.14g",math.floor(value * 100) * 0.01)
		end
	end
end

return Handler