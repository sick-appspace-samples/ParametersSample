--[[----------------------------------------------------------------------------

  Application Name:
  ParametersSample

  Summary:
  Introduction for using cid parameters. Reading and writing values to a parameter
  from script and from user interface.
  
  Description:
  This App contains a cid parameters file where some variables are declared. The parameter
  values are changed depending on any change of DI1 or on any change in the user interface.
  The parameter values can also be saved permanently. These parameters can contain various
  variable types and also structures. The variable values can be read and written from the
  script. Also a direct binding to a user interface control is possible.
  
  How to run:
  The sample can be run using the emulator. The values will be printed to
  the console on initialization and on any change. The keyboard key 1 can be used
  inside the emulator tab to toggle the digital input. The user interface can be
  accessed by opening a web browser on localhost (127.0.0.1). The values can be
  changed in the user interface and pressing "Save permanent" will save the parameters,
  so that they keep their value even after rebooting the device.
  
------------------------------------------------------------------------------]]

--Start of Global Scope---------------------------------------------------------

-- Creating handle to Digital In 1
local DI1Port = Connector.DigitalIn.create("DI1")

--End of Global Scope-----------------------------------------------------------

-- This function reads all variables
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

-- This callback function reads a parameter, increments it by one and
-- stores the new value. The 'apply' trigges the change event.
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

--Declaration of the 'main' function as an entry point for the event loop
--@main()
local function main()
  -- call the read function directly after start up
  readAll()
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register("Engine.OnStarted", main)

-- This callback function is called as soon any parameter has changed
local function handleOnParametersChanged()
  readAll()
end
--Registration of the 'handleOnParametersChanged' function to the 'Parameters.OnChange' event
Script.register("Parameters.OnParametersChanged", handleOnParametersChanged)

-- This function is called from the webpage button to store the parameters permanent
local function savePermanent()
  Parameters.savePermanent()
  print("Parameters are stored permanently now")
end
-- Serving the save permanent function for the webpage
Script.serveFunction("ParametersSample.savePermanent", savePermanent)

--End of Function and EventScope------------------------------------------------
