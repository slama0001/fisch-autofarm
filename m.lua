Drawing.clear()
_G.Toggle = false
local completion = 0.01
-- if bar is higher than this percent it casts (0.01 - 0.99)
local speed = 0.1
-- go from 0.15 to however high you want. changes how fast you click on the shake buttons

-- dont change
local minSpeed = 0.02
local maxSpeed = 0.15
local casted = false
local MouseService = findfirstchild(Game, "MouseService")
local screen = getscreendimensions()
local oldname = nil
local oldpos = {
    X = 0,
    Y = 0
}

_G.auto = false
wait(2)
_G.auto = true

local function getbutton()
    local PlayerGui = game.Players.localPlayer:FindFirstChild("PlayerGui")
    if PlayerGui then
        local shakeui = PlayerGui:FindFirstChild("shakeui")
        if shakeui then
            local mainui = shakeui:FindFirstChild("safezone")
            if mainui then
                local button = mainui:FindFirstChild("button")
                return button
            end
        end
    end
    return nil
end

local function Power(character)
    local children = getchildren(character)
    for i = 1, #children do
        if getname(children[i]) == "power" then
            return children[i]
        end
    end
    return nil
end

local function setrodname(name)
    local localplayer = getlocalplayer()
    if not localplayer then wait() end

    local Character = getcharacter(localplayer)
    if Character then
        local Tools = findfirstchildofclass(Character, "Tool")
        if Tools and string.match(getname(Tools), "Rod") then
            if not oldname and string.match(getname(Tools), "Rod") then oldname = getname(Tools) end
            sigma = Tools
            if sigma then
                local balloon = getmemoryvalue(sigma, 0x70, "qword")
                local ptr = pointer_to_user_data(balloon)
                local name = setmemoryvalue(ptr, 0x0, "string", name)
            end
        end
    end
end


local function PowerBar(power)
    local firstChild = getchildren(power)[1]
    return firstChild
end

local function Bar(powerbar)
    local children = getchildren(powerbar)
    for i = 1, #children do
        if getname(children[i]) == "bar" then
            return children[i]
        end
    end
    return nil
end



local Text1 = Drawing.new("Text")
local Text2 = Drawing.new("Text")
local Text3 = Drawing.new("Text")
local Screen = getscreendimensions()
Text1.Text = "OFF LCTRL TO ENABLE"
Text2.Text = "SPEED: " .. speed
Text3.Text = "F6 TO LOWER F7 TO HIGHER"
Text1.Size = 15
Text2.Size = 15
Text3.Size = 15
Text1.Visible = true
Text2.Visible = true
Text3.Visible = true
Text1.Color = {255,0,0}
Text2.Color = {255,255,255}
Text3.Color = {255,255,255}
Text1.Font = 14
Text2.Font = 14
Text3.Font = 14
Text1.Position = {0, Screen.y/2}
Text2.Position = {0, Screen.y/2 + 30}
Text3.Position = {0, Screen.y/2 + 15}
local function keycheck()
    local cached = tick()
    while true do
        local current = tick()
        for _, key in ipairs(getpressedkeys()) do
            if key == "LeftCtrl" then
                _G.Toggle = not _G.Toggle
                cached = current
            elseif key == "L" and current - cached > 0.8 then
                _G.legit = not _G.legit
                cached = current
            elseif key == "F6" then
               speed = math.max(speed - 0.01, minSpeed)
			   speed = math.floor(speed * 100 + 0.5) / 100
               cached = current
            elseif key == "F7" then
                speed = math.min(speed + 0.01, maxSpeed)
				speed = math.floor(speed * 100 + 0.5) / 100
                cached = current
            end
            if _G.Toggle then
                Text1.Color = {0,255,0}
                Text1.Text = "ON LCTRL TO DISABLE"
                Text2.Text = "SPEED: " .. speed
            else
                Text1.Color = {255,0,0}
                Text1.Text = "OFF LCTRL TO ENABLE"
            end
            wait(0.05)
        end
        wait()
    end
end

spawn(keycheck)
print("start of log:")
while _G.auto == true do
    if not _G.Toggle then 
        wait()
        continue 
    end
    if _G.Toggle and not casted then
        local players = findfirstchild(Game, "Players")
        if not players then wait() continue end

        local localplayer = getlocalplayer()
        if not localplayer then wait() continue end

        local Character = getcharacter(localplayer)
        if not Character then wait() continue end

        local Tools = findfirstchildofclass(Character, "Tool")
        if not Tools or not string.match(getname(Tools), "Rod") then wait() continue end

        local RluaCharacter = game.Players.localPlayer.Character
        if not RluaCharacter or type(RluaCharacter) ~= "table" then wait() continue end

        local RLuaTool = RluaCharacter:FindFirstChildOfClass("Tool")
        if not RLuaTool or not string.match(RLuaTool.Name, "Rod") then wait() continue end

        local RLuaValues = RLuaTool:FindFirstChild("values")
        if not RLuaValues or type(RLuaValues) ~= "table" then wait() continue end

        local RluaCast = RLuaValues:FindFirstChild("casted")
        if not RluaCast or type(RluaCast) ~= "table" then wait() continue end

        casted = RluaCast.Value

        if casted == false then
            pressed = false
        end
            if casted ~= true then
            if not pressed then
                mouse1press()
                pressed = true
            end

            local humanoidRootPart = findfirstchild(Character, "HumanoidRootPart")
            if not humanoidRootPart then wait() continue end

            local power = Power(humanoidRootPart)
            if not power then wait() continue end

            local powerbar = PowerBar(power)
            if not powerbar then wait() mouse1release() print("typeshit") pressed = false continue end

            local bar = Bar(powerbar)
            if not bar then wait() print("bar not found") continue end

            mouse1release()
        end
        wait()
        if not casted then wait(speed) end
    end

    local button = getbutton()
    if _G.Toggle and casted and button then
        local mice = getmouseposition()
        local X = button:GetMemoryValue(0x110, "float")
        local Y = button:GetMemoryValue(0x198, "float")
        local Size = button:GetMemoryValue(0x118, "float")
        local CalcX = X + (Size / 2)
        local CalcY = Y + (Size / 15)
    
		local lastButton = nil
		local clicked = false

		local button = getbutton()
		if button then

			if lastButton ~= button then
				clicked = false
				lastButton = button
			end


			if CalcX > 50 and CalcY > 50 and not clicked then
				mousemoveabs(CalcX, CalcY)
				mousemoveabs(CalcX + math.random(1,4), CalcY - math.random(1,4))
				wait(0.003)
				mousemoveabs(CalcX + math.random(-Size / 8, Size / 8), CalcY - math.random(-Size / 8, Size / 8))
				mouse1click()
				
				clicked = true
			end
		end

		wait(speed)

    end
		
    -- REELING PART
    if _G.Toggle and casted then
        setrodname("Developers Rod") 
    end

    casted = false
    wait()
end
