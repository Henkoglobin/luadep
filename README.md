# luadep
A Lua module that allows a form of dependency injection.

When using luadep, you can define the interfaces that a module implements as well as its dependencies:

```lua
local module = require("luadep.module")

local car = {
	-- ...
}

return module(car)
	:isA("ICar")
	:dependsOn("IEngine")
```

In order to retrieve a module, you can instantiate a container and add modules to it. Afterwards, you can get the actual module:

```lua

local container = require("luadep.container")

-- Get dependent modules
local car = require("car")
local engine = require("engine")

local myContainer = container()
myContainer:collect(car)
myContainer:collect(engine)

local myCar = myContainer:get("ICar")

```
