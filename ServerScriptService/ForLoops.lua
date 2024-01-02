return {
	PairsForLoop = function(Function, Data)
		for Key, Value in pairs(Data) do
			Function(Key, Value)
		end
	end,
}
