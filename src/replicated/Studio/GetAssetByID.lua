local InsertService = game:GetService("InsertService")

local function getImageFromAssetId(assetId)
    local success, assetInfo = pcall(function()
        return InsertService:GetAssetInfo(assetId)
    end)

    if success and assetInfo and assetInfo.AssetTypeId == Enum.AssetType.Image.Value then
        return assetInfo.ThumbnailUrl
    else
        warn("Failed to get image from asset ID:", assetId)
        return nil
    end
end

local assetId = 12520031 
local imageUrl = getImageFromAssetId(assetId)
if imageUrl then
    print("Image URL:", imageUrl)
else
    print("Failed to retrieve image for asset ID:", assetId)
end
