module Hello where

import Clash.Prelude
import Clash.Annotations.TH

import Barbies
import Barbies.Bare
import Data.Barbie.TH

declareBareB [d|
  data MyBarbie = MyBarbie
      { bar :: "BAR" ::: Bool
      , baz :: "BAZ" ::: Int
      } |]

topEntity :: "FOO" ::: MyBarbie Covered (Signal System)
topEntity = MyBarbie (pure True) (pure 0)

makeTopEntity 'topEntity
