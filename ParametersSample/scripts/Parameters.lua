
--Start of Global Scope---------------------------------------------------------

-- Creating handle to Digital In 1
local DI1Port = Connector.DigitalIn.create("DI1")

--End of Global Scope-----------------------------------------------------------

---This function reads all variables
local function readAll()
  -- Reading the device type. This is an internal variable
  local value = Parameters.get("DItype")
  if (value ~= nil) then --get() returns nil if reading fails
    print("Device type: " .. value)
  else
    print("Device type variable could not be read")
  end
  -- Reading a string variable
  value = Parameters.get("ASampleStringVar")
  if (value ~= nil) then
    print("ASampleStringVar: " .. value)
  else
    print("ASampleStringVar: could not be read")
  end
  -- Reading an integer variable
  value = Parameters.get("ASampleIntegerVar")
  if (value ~= nil) then
    print("ASampleIntegerVar: " .. value)
  else
    print("ASampleIntegerVar: could not be read")
  end
  -- Reading an float variable
  value = Parameters.get("ASampleFloatVar")
  if (value ~= nil) then
    print("ASampleFloatVar: " .. value)
  else
    print("ASampleFloatVar: could not be read")
  end
  -- Reading a struct variable
  value = Parameters.getNode("ASampleStructVar")
  if (value ~= nil) then
    local myBool = Parameters.Node.get(value, "MyBool")
    local myInt = Parameters.Node.get(value, "MyInt")
    print("ASampleStructVar: " .. tostring(myBool) .. ", " .. myInt)
  else
    print("ASampleStructVar: could not be read")
  end
end

---This callback function reads a parameter, increments it by one and
---stores the new value. The 'apply' trigges the change event.
local function handleIN1Change()
  local value = Parameters.get("ASampleIntegerVar")
  if (value ~= nil) then
    value = value + 1
    local ret =  Parameters.set("ASampleIntegerVar",value)
    if (ret == false) then -- Checking if parameter set was successful
      -- this might also be the case because counter is out of range
      print("Counter could not be incremented")
    else
      print("Counter: " .. value)
      Parameters.apply() -- causes handleOnParametersChanged() to be called
    end
  end
end
--Registration of the 'handleIN1Change' function to the 'OnChange' event of DI1
Connector.DigitalIn.register(DI1Port, "OnChange", handleIN1Change)

---Declaration of the 'main' function as an entry point for the event loop
local function main()
  -- call the read function directly after start up
  readAll()
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register("Engine.OnStarted", main)

---This callback function is called as soon any parameter has changed
local function handleOnParametersChanged()
  readAll()
end
--Registration of the 'handleOnParametersChanged' function to the 'Parameters.OnChange' event
Script.register("Parameters.OnParametersChanged", handleOnParametersChanged)

---This function is called from the webpage button to store the parameters permanent
local function savePermanent()
  Parameters.savePermanent()
  print("Parameters are stored permanently now")
end
-- Serving the save permanent function for the webpage
Script.serveFunction("ParametersSample.savePermanent", savePermanent)

--End of Function and EventScope------------------------------------------------
