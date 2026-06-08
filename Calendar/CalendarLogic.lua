function Initialize()
    -- Nothing needed here
end

function Update()
    local time = os.date("*t")
    local current_day = time.day
    local current_month = time.month
    local current_year = time.year
    
    local days_in_month = 31
    if current_month == 4 or current_month == 6 or current_month == 9 or current_month == 11 then
        days_in_month = 30
    elseif current_month == 2 then
        if current_year % 4 == 0 and (current_year % 100 ~= 0 or current_year % 400 == 0) then
            days_in_month = 29
        else
            days_in_month = 28
        end
    end
    
    local first_day = os.time{year=current_year, month=current_month, day=1}
    local weekday = tonumber(os.date("%w", first_day)) -- 0=Sun, 1=Mon, ..., 6=Sat
    
    -- We want Monday=0, Tuesday=1, ..., Sunday=6
    local offset = weekday - 1
    if offset < 0 then offset = 6 end
    
    local pastColor = SKIN:GetVariable("PastColor", "FFFFFF")
    local currentColor = SKIN:GetVariable("CurrentColor", "EA1537")
    local futureColor = SKIN:GetVariable("FutureColor", "404040")
    local bgColor = SKIN:GetVariable("BgColor", "404040")
    
    local displayType = SKIN:GetVariable("DisplayType", "Dot")
    
    if displayType == "Dot" then
        for i = 1, 31 do
            local cell_index = (i - 1) + offset
            local col = cell_index % 7
            local row = math.floor(cell_index / 7)
            local x = 26 + col * 23
            local y = 65 + row * 23
            
            local color = futureColor
            if i < current_day then
                color = pastColor
            elseif i == current_day then
                color = currentColor
            end

            if i <= days_in_month then
                SKIN:Bang("!ShowMeter", "MeterDay" .. i)
                SKIN:Bang("!SetOption", "MeterDay" .. i, "Shape", "Ellipse " .. x .. "," .. y .. ",6 | StrokeWidth 0 | FillColor " .. color)
            else
                SKIN:Bang("!HideMeter", "MeterDay" .. i)
            end
        end
    elseif displayType == "Number" then
        for i = 1, 31 do
            local cell_index = (i - 1) + offset
            local col = cell_index % 7
            local row = math.floor(cell_index / 7)
            local x = 26 + col * 23
            local y = 65 + row * 23
            
            -- All numbers should be white (or black in light mode), which is pastColor
            local color = pastColor

            if i <= days_in_month then
                SKIN:Bang("!ShowMeter", "MeterDayText" .. i)
                SKIN:Bang("!SetOption", "MeterDayText" .. i, "X", x)
                SKIN:Bang("!SetOption", "MeterDayText" .. i, "Y", y)
                SKIN:Bang("!SetOption", "MeterDayText" .. i, "FontColor", color)
                
                if i == current_day then
                    SKIN:Bang("!ShowMeter", "MeterDayBg")
                    SKIN:Bang("!SetOption", "MeterDayBg", "Shape", "Ellipse " .. x .. "," .. y .. ",10 | StrokeWidth 0 | FillColor " .. currentColor)
                    -- For current day, we want high contrast on the red circle
                    SKIN:Bang("!SetOption", "MeterDayText" .. i, "FontColor", pastColor) 
                end
            else
                SKIN:Bang("!HideMeter", "MeterDayText" .. i)
            end
        end
        -- Hide the background circle if the current day is somehow not in the month (edge case)
        if current_day > days_in_month then
            SKIN:Bang("!HideMeter", "MeterDayBg")
        end
    end
    
    return tostring(days_in_month)
end
