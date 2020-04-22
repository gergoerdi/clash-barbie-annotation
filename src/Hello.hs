module Hello where

import Clash.Prelude
import Clash.Annotations.TH

import Barbies
import Barbies.Bare
import Data.Barbie.TH

declareBareB [d|
  data MyBarbieTH = MyBarbieTH
      { bar :: "BAR" ::: Bool
      , baz :: "BAZ" ::: Int
      } |]

-- This one works
data MyBarbieManual1 c f = MyBarbieManual1
    { bar' :: "BAR" ::: Wear c f Bool
    , baz' :: "BAZ" ::: Wear c f Int
    }

-- This is what `MyBarbieTH` is translated into...
data MyBarbieManual2 c f = MyBarbieManual2
    { bar2 :: Wear c f ("BAR" ::: Bool)
    , baz2 :: Wear c f ("BAZ" ::: Int)
    }

topEntity
    :: ( "FOO" ::: MyBarbieTH Covered (Signal System)
       , "QUUX" ::: MyBarbieManual1 Covered (Signal System)
       , "FLOB" ::: MyBarbieManual2 Covered (Signal System)
       )
topEntity =
    ( MyBarbieTH (pure True) (pure 0)
    , MyBarbieManual1 (pure True) (pure 0)
    , MyBarbieManual2 (pure True) (pure 0)
    )

makeTopEntity 'topEntity
