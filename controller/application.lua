current_temp = nil

function setRelais(state)
    if(state) then
        gpio.write(RELAIS_PIN, gpio.LOW)
    else
        gpio.write(RELAIS_PIN, gpio.HIGH)
    end
end

function sendStateChangedEcho(state)
    local new_state = {state=nil}
    if(state) then
        new_state["state"] = "on"
    else
        new_state["state"] = "off"
    end
    ws:send(sjson.encode(new_state))
end

function sendCurrentTemperature()
    ws:send(sjson.encode({temperature=current_temp}))
end

function getTemperature(callback)
    ds18b20.read(
    function(ind,rom,res,temp,tdec,par)
        current_temp = round(temp, 1)
        callback(current_temp)
    end,{})
end

function sendInitialState()
    -- make sure fridge is really turned off
    setRelais(false)
    getTemperature(
    function(temp)
        local message = {state="off", temperature=temp}
        ws:send(sjson.encode(message))
        print("Initial state sent.")
    end)
end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

ws:on("receive", function(_, json_message, opcode)
  if(opcode == 1) then
    local message = sjson.decode(json_message)
    local requested_state = nil
    if(message["state"] == "on") then
        requested_state = true
    elseif(message["state"] == "off") then
        requested_state = false
    end
    setRelais(requested_state)
    sendStateChangedEcho(requested_state)
  end
end)

temperature_timer = tmr.create()
temperature_timer:register(1000, tmr.ALARM_AUTO, function (t)
    local old_temp = current_temp
    getTemperature(
    function(new_temp)
        if(new_temp ~= old_temp) then
            sendCurrentTemperature()
        end
    end)
end)
ds18b20.setup(TEMPERATURE_PIN)
temperature_timer:start()
sendInitialState()