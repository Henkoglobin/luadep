-- container.lua
-- 
-- Provides a form of dependency injection for Lua projects

local container = setmetatable({}, {
	__call = function(self, ...)
		return setmetatable(self.new(...), self)
	end
})

container.__index = container

function container.new()
	return {
		modules = {},
		finished = {}
	}
end

function container:collect(module)
	for _, interface in pairs(module.interfaces) do
		if self.modules[interface] == nil then
			self.modules[interface] = {}
		end

		table.insert(self.modules[interface], module)
	end
end

function container:get(interface)
	local candidates = self.modules[interface] or {}

	for _, module in pairs(candidates) do
		if self.finished[module] then
			return module.module
		end

		-- Get dependencies of this module 
		local dependencies = module.dependencies

		for _, dependency in pairs(dependencies) do
			local resolved = self:get(dependency.interface)

			if not resolved then
				error(string.format("Cannot resolve dependency '%s' of module %s %s", dependency.interface, module.name, module.version))
			end

			module.inject(module.module, dependency.interface, resolved, dependency.multiple)

			if not dependency.multiple then 
				break 
			end
		end

		self.finished[module] = true

		return module.module
	end
end

return container
