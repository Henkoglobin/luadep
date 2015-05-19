-- demo.lua
-- 
-- Demonstrates how to use luadep.

local module = require("module")
local container = require("container")

local car = module({
		vroom = function(self)
			self.Engine:start()
			print("Vroom!")
			self.Engine:stop()
		end
	})
	:setName("VanillaCar")
	:setVersion("1.0.0")
	:isA("Car")
	:dependsOn("Engine")
	:onInject(function(self, interface, mod, definition)
		-- Verify that, even when a module is requested multiple times,
		-- dependencies are only injected once.
		if self.wasInjected then
			error("Dependency has already been injected!")
		end

		self[interface] = mod
		self.wasInjected = true
	end)

local engine = module({
		start = function(self)
			print("Engine started.")
		end,
		stop = function(self)
			print("Engine stopped.")
		end
	})
	:setName("VanillaEngine")
	:setVersion("1.0.0-beta")
	:isA("Engine")

local myContainer = container()
myContainer:collect(car)
myContainer:collect(engine)

local myCar = myContainer:get("Car")
myCar:vroom()

local myCar2 = myContainer:get("Car")
myCar2:vroom()