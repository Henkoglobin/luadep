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

function container:get(interface, multiple)
	local candidates = self.modules[interface] or {}
	local ret = {}
	
	for _, module in pairs(candidates) do
		if self.finished[module] then
			if multiple then
				table.insert(ret, module.module)
			else
				return module.module
			end
		end

		-- Get dependencies of this module 
		local dependencies = module.dependencies

		for _, dependency in pairs(dependencies) do
			local resolved = self:get(dependency.interface, dependency.allowMultiple)

			if resolved then
				if not next(resolved) then
					if dependency.allowNone then
						-- Initialize the property nonetheless by injecting nil
						module.inject(module.module, dependency.interface, nil, dependency)
					else
						error(string.format("Cannot resolve dependency '%s' of module %s %s", dependency.interface, module.name, module.version))
					end
				end

				if dependency.allowMultiple then
					for _, resolvedModule in pairs(resolved) do
						module.inject(module.module, dependency.interface, resolvedModule, dependency)
					end
				else
					module.inject(module.module, dependency.interface, resolved, dependency)
				end
			elseif not dependency.allowNone then
				error(string.format("Cannot resolve dependency '%s' of module %s %s", dependency.interface, module.name, module.version))
			end
		end

		self.finished[module] = true

		if multiple then
			table.insert(ret, module.module)
		else
			return module.module
		end
	end
	
	-- If we reach this point,
	-- a: multiple was true ==> return table
	-- b: multiple was false, but no module was found ==> return nil
	return multiple and ret or nil
end

function container:validate()
	local missing = {}

	for interface, modules in pairs(self.modules) do
		print("Checking " .. interface)

		for _, module in pairs(modules) do
			print("Checking module " .. module.name)

			-- check every dependency of current module
			for _, definition in pairs(module.dependencies) do
				print("Checking definition " .. definition.interface)

				if not self.modules[definition.interface] then
					missing[module.name] = definition.interface
				end
			end
		end
	end

	return not next(missing), missing
end

return container
