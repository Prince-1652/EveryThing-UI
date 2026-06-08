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
    
    local pastColor = SKIN:GetVariable("PastColor", "FFFFFF")
    local currentColor = SKIN:GetVariable("CurrentColor", "EA1537")
    local futureColor = SKIN:GetVariable("FutureColor", "404040")
    
    for i = 1, 31 do
        local col = (i - 1) % 7
        local row = math.floor((i - 1) / 7)
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
    
    return tostring(days_in_month)
end
