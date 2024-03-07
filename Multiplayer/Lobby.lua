--- STEAMODDED HEADER
--- STEAMODDED SECONDARY FILE

----------------------------------------------
------------MOD LOBBY-------------------------

Lobby = {
  connected = false,
  code = nil,
  type = "",
  config = {},
  user_id = nil,
  username = "Guest"
}

Connection_Status_UI = nil

local endRoundRef = end_round
function end_round()
  if Lobby.code then
    G.GAME.chips = G.GAME.blind.chips
  end
  endRoundRef()
end

local function get_connection_status_ui()
  return UIBox({
		definition = {
			n = G.UIT.ROOT,
			config = {
				align = "cm",
				colour = G.C.UI.TRANSPARENT_DARK
			},
			nodes = {
				{
					n = G.UIT.T,
					config = {
						scale = 0.3,
						text = (Lobby.code and 'In Lobby') or (Lobby.user_id and 'Connected to Service') or 'WARN: Cannot Find Multiplayer Service',
						colour = G.C.UI.TEXT_LIGHT
					}
				}
			}
		},
		config = {
			align = "tri",
			bond = "Weak",
			offset = {
				x = 0,
				y = 0.9
			},
			major = G.ROOM_ATTACH
		}
	})
end

function Lobby.update_connection_status()
  if Connection_Status_UI then
    Connection_Status_UI:remove()
    Connection_Status_UI = get_connection_status_ui()
  end
end

local gameMainMenuRef = Game.main_menu
function Game.main_menu(arg_280_0, arg_280_1)
	Connection_Status_UI = get_connection_status_ui()
	gameMainMenuRef(arg_280_0, arg_280_1)
end

function create_UIBox_view_code()
	local var_495_0 = 0.75

	return (create_UIBox_generic_options({
		contents = {
			{
				n = G.UIT.R,
				config = {
					padding = 0,
					align = "cm"
				},
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = Lobby.code,
							shadow = true,
							scale = var_495_0 * 0.6,
							colour = G.C.UI.TEXT_LIGHT
						}
					}
				}
			}
		}
	}))
end

-- Stops a multiplayer run from being saved, should prevent it from overriding singleplayer saved run
local compressAndSaveRef = compress_and_save
function compress_and_save(_file, _data)
  local save_file_name = 'save.jkr'
  if Lobby.code and _file:sub(-#save_file_name) == save_file_name then return end -- In lobby, and trying to save the run
  compressAndSaveRef(_file, _data)
end

function G.FUNCS.lobby_setup_run(arg_736_0)
	G.FUNCS.start_run(arg_736_0, {
    stake = 1,
    challenge = {
      name = 'Multiplayer',
      id = 'c_multiplayer_1',
      rules = {
          custom = {
          },
          modifiers = {
          }
      },
      jokers = {
      },
      consumeables = {
      },
      vouchers = {
      },
      deck = {
          type = 'Challenge Deck'
      },
      restrictions = {
          banned_cards = {
              {id = 'j_diet_cola'}, -- Intention to disable skipping
              {id = 'j_mr_bones'},
              {id = 'v_hieroglyph'},
              {id = 'v_petroglyph'},
          },
          banned_tags = {
          },
          banned_other = {
          }
      }
  }
  })
end

function G.FUNCS.lobby_options(arg_736_0)
	G.FUNCS.overlay_menu({
		definition = override_main_menu_play_button()
	})
end

function G.FUNCS.view_code(arg_736_0)
	G.FUNCS.overlay_menu({
		definition = create_UIBox_view_code()
	})
end

function G.FUNCS.lobby_leave(arg_736_0)
  Lobby.code = nil
  Lobby.update_connection_status()
end

local function create_UIBox_lobby_menu()
  local text_scale = 0.45

  local t = {
    n = G.UIT.ROOT, 
    config = {
      align = "cm",
      colour = G.C.CLEAR
    }, 
    nodes = { 
      {
        n = G.UIT.C, 
        config = { 
          align = "bm"
        }, 
        nodes = {      
          {
            n = G.UIT.R, 
            config = {
              align = "cm", 
              padding = 0.2, 
              r = 0.1, 
              emboss = 0.1, 
              colour = G.C.L_BLACK, 
              mid = true
            }, 
            nodes = {
              UIBox_button({
                id = 'lobby_menu_start', 
                button = "lobby_setup_run", 
                colour = G.C.BLUE, 
                minw = 3.65, 
                minh = 1.55, 
                label = {'START'}, 
                scale = text_scale*2, 
                col = true
              }),
              {
                n = G.UIT.C, 
                config = { 
                  align = "cm"
                }, 
                nodes = {
                  UIBox_button{
                    button = 'lobby_options', 
                    colour = G.C.ORANGE, 
                    minw = 3.15, 
                    minh = 1.35, 
                    label = {'LOBBY OPTIONS'}, 
                    scale = text_scale * 1.2, 
                    col = true
                  },
                  {
                    n = G.UIT.C, 
                    config = {
                      align = "cm", 
                      minw = 0.2
                    }, 
                    nodes = {}
                  },
                  {
                    n = G.UIT.C, 
                    config = {
                      align = "tm", 
                      minw = 2.65
                    }, 
                    nodes = {
                      {
                        n = G.UIT.R,
                        config = {
                          padding = 0.2,
                          align = "cm"
                        },
                        nodes = {
                          {
                            n = G.UIT.T,
                            config = {
                              text = 'Connected Players:',
                              shadow = true,
                              scale = text_scale * 0.8,
                              colour = G.C.UI.TEXT_LIGHT
                            }
                          }
                        },
                      },
                      {  
                        n = G.UIT.R,
                        config = {
                          padding = 0.2,
                          align = "cm"
                        },
                        nodes = {
                          {
                            n = G.UIT.T,
                            config = {
                              text = Lobby.username,
                              shadow = true,
                              scale = text_scale * 0.8,
                              colour = G.C.UI.TEXT_LIGHT
                            }
                          }
                        }
                      }
                    }
                  },
                  {
                    n = G.UIT.C, 
                    config = {
                      align = "cm", 
                      minw = 0.2
                    }, 
                    nodes = {}
                  },
                  UIBox_button{
                    button = 'view_code', 
                    colour = G.C.PALE_GREEN, 
                    minw = 3.15, 
                    minh = 1.35, 
                    label = {'VIEW CODE'}, 
                    scale = text_scale * 1.2, 
                    col = true
                  },
                }
              },
              UIBox_button{
                id = 'lobby_menu_leave', 
                button = "lobby_leave", 
                colour = G.C.RED, 
                minw = 3.65, 
                minh = 1.55, 
                label = {'LEAVE'}, 
                scale = text_scale*1.5, 
                col = true
              },
            }
          },
      }},
    }}
  return t
end

local setMainMenuUIRef = set_main_menu_UI
function set_main_menu_UI()
  if Lobby.code then
    G.MAIN_MENU_UI = UIBox({
      definition = create_UIBox_lobby_menu(), 
      config = {
        align="bmi", 
        offset = {
          x = 0,
          y = 10
        }, 
        major = G.ROOM_ATTACH, 
        bond = 'Weak'
      }
    })
    G.MAIN_MENU_UI.alignment.offset.y = 0
    G.MAIN_MENU_UI:align_to_major()

    G.CONTROLLER:snap_to{node = G.MAIN_MENU_UI:get_UIE_by_ID('lobby_menu_start')}
  else
    setMainMenuUIRef()
  end
end

local in_lobby = false
local gameUpdateRef = Game.update
function Game:update(arg_298_1)
  if (Lobby.code and not in_lobby) or (not Lobby.code and in_lobby) then
    in_lobby = not in_lobby
    self.FUNCS.go_to_menu()
  end
  gameUpdateRef(self, arg_298_1)
end

return Lobby

----------------------------------------------
------------MOD LOBBY END---------------------