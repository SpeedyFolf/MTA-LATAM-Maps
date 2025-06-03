local clothes = {}
for i = 0, 16 do
	local clothesIndex = 0
	clothes[i] = {}
	while(getClothesByTypeIndex(i, clothesIndex)) do
		local clothesTexture, clothesModel = getClothesByTypeIndex(i, clothesIndex)
		table.insert(clothes[i], {clothesTexture, clothesModel})
		clothesIndex = clothesIndex + 1
	end
end

function changeClothes()
	for i = 4, 17 do
		removePedClothes(source, i)
	end
	addPedClothes(source, "vest", "vest", 0)
	addPedClothes(source, "player_face", "head", 1)
	addPedClothes(source, "jeansdenim", "jeans", 2)
	addPedClothes(source, "sneakerbincblk", "sneaker", 3)
end

addEventHandler("onPlayerSpawn", root, changeClothes)
addEventHandler("onPlayerVehicleEnter", root, changeClothes)
