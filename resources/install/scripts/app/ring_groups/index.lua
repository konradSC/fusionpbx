				if (ring_group_strategy == "enterprise") then
					---get destination that are using follow me
					cmd = "user_data ".. destination_number .."@" ..domain_name.." var follow_me_enabled";
					if (api:executeString(cmd) == "true") then
						--get the follow me destinations
						cmd = "user_data ".. destination_number .."@" ..domain_name.." var follow_me_destinations";
						result_follow_me_destinations = api:executeString(cmd);
						freeswitch.consoleLog("notice", "[ring groups][follow_me] key " .. key .. " " .. cmd .. " ".. result_follow_me_destinations .."\n");
	
						follow_me_destinations = explode(",[", result_follow_me_destinations);
						x = 0;
						for k, v in pairs(follow_me_destinations) do
							--increment the ordinal value
							x = x + 1;
	
							--seperate the variables from the destination
							destination = explode("]", v);
	
							--set the variables and clean the variables string
							variables = destination[1];
							variables = variables:gsub("%[", "");
	
							--send details to the console
							freeswitch.consoleLog("notice", "[ring groups][follow_me] variables ".. variables .."\n");
							freeswitch.consoleLog("notice", "[ring groups][follow_me] destination ".. destination[2] .."\n");
	
							--add to the destinations array
							--if destinations[x] == nil then destinations[x] = {} end
							destinations[key]['destination_number'] = destination[2];
							destinations[key]['domain_name'] = domain_name;
							destinations[key]['destination_delay'] = '0';
							destinations[key]['destination_timeout'] = '30';
	
							--add the variables to the destinations array
							variable_array = explode(",", variables);
							for k2, v2 in pairs(variable_array) do
								array = explode("=", v2);
								if (array[2] ~= nil) then
									destinations[key][array[1]] = array[2];
								end
							end
	
							--if confirm is true true then set it to prompt
							if (destinations[key]['confirm']  ~= nil and destinations[key]['confirm']  == 'true') then
								destinations[key]['destination_prompt'] = '1';
							end
	
						end
					end
				end
			end
