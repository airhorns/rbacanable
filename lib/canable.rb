require 'active_support'
require 'canable/role'
require 'canable/canable'
require 'canable/cans'
require 'canable/actor'
require 'canable/enforcers'

module Canable
  Version = '0.2.2'
end

Canable.add(:view,    :viewable)
Canable.add(:create,  :creatable)
Canable.add(:update,  :updatable)
Canable.add(:destroy, :destroyable)