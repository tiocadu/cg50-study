-- the interface for a State is:
-- Render, Update, Enter and Exit methods

StateMachine = Class{}

function StateMachine:init(states)
  self._empty = {
    enter = function() end,
    update = function() end,
    render = function() end,
    exit = function() end
  }
  self._states = states or {}
  self._current = self._empty
end

function StateMachine:change(newState)
  if self._states[newState] then
    self._current:exit()
    local nextState = self._states[newState]()
    nextState:enter()
    self._current = nextState
  end
end

function StateMachine:update(dt)
  self._current:update(dt)
end

function StateMachine:render()
  self._current:render()
end