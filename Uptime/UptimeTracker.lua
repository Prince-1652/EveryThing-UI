function Initialize()
    savedDate = SKIN:GetVariable('SavedDate', '0')
    todayUptime = tonumber(SKIN:GetVariable('TodayUptime', '0'))
    if todayUptime == nil then todayUptime = 0 end
    lastUptime = nil
    lastTime = os.time()
end

function Update()
    local currentDate = os.date('%Y%m%d')
    local currentMeasureUptime = tonumber(SKIN:GetMeasure('MeasureUptime'):GetValue())
    local currentTime = os.time()
    
    local numCurrentDate = tonumber(currentDate)
    local numSavedDate = tonumber(savedDate)
    
    if numSavedDate == nil then numSavedDate = 0 end
    
    if numCurrentDate > numSavedDate and numSavedDate ~= 0 then
        savedDate = currentDate
        todayUptime = 0
        SKIN:Bang('!WriteKeyValue', 'Variables', 'SavedDate', savedDate, SKIN:GetVariable('CURRENTPATH') .. 'UptimeData.inc')
        SKIN:Bang('!WriteKeyValue', 'Variables', 'TodayUptime', '0', SKIN:GetVariable('CURRENTPATH') .. 'UptimeData.inc')
    elseif numSavedDate == 0 then
        savedDate = currentDate
        SKIN:Bang('!WriteKeyValue', 'Variables', 'SavedDate', savedDate, SKIN:GetVariable('CURRENTPATH') .. 'UptimeData.inc')
    end

    if lastUptime == nil or currentMeasureUptime == 0 then
        if currentMeasureUptime > 0 then
            lastUptime = currentMeasureUptime
        end
        
        local hours = math.floor(todayUptime / 3600)
        local minutes = math.floor((todayUptime % 3600) / 60)
        local formatted = string.format('%dh %dm', hours, minutes)
        SKIN:Bang('!SetVariable', 'FormattedUptime', formatted)
        
        return todayUptime
    end

    local diff = currentMeasureUptime - lastUptime
    
    if diff < 0 then
        -- PC restarted or measure reset
        diff = currentTime - lastTime
        if diff < 0 then diff = 1 end
    end
    
    todayUptime = todayUptime + diff
    lastUptime = currentMeasureUptime
    lastTime = currentTime
    
    -- Write to file every ~60 seconds to save state
    if not tickCounter then tickCounter = 0 end
    tickCounter = tickCounter + 1
    if tickCounter >= 60 then
        SKIN:Bang('!WriteKeyValue', 'Variables', 'TodayUptime', tostring(math.floor(todayUptime)), SKIN:GetVariable('CURRENTPATH') .. 'UptimeData.inc')
        tickCounter = 0
    end
    
    -- Format string
    local hours = math.floor(todayUptime / 3600)
    local minutes = math.floor((todayUptime % 3600) / 60)
    local formatted = string.format('%dh %dm', hours, minutes)
    SKIN:Bang('!SetVariable', 'FormattedUptime', formatted)
    
    return todayUptime
end
