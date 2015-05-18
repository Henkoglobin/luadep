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
	:isA("Car")
	:dependsOn("Engine")

local engine = module({
		start = function(self)
			print("Engine started.")
		end,
		stop = function(self)
			print("Engine stopped.")
		end
	})
	:isA("Engine")

local myContainer = container()
myContainer:collect(car)
myContainer:collect(engine)

local myCar = myContainer:get("Car")
myCar:vroom()