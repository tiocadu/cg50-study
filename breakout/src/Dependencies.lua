-- importing constants
require 'src/constants'

-- instead of using a package manager, i'm going with local dependences
-- https://github.com/Ulydev/push/blob/master/push.lua
push = require 'libs/push'

-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'libs/class'

-- import our sprites and quads
require 'src/Util'

-- objects
require 'src/Paddle'

-- states
require 'src/StateMachine'
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'
