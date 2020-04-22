{-# LANGUAGE TypeFamilies, DataKinds #-}
module Hello where

import Clash.Prelude
import Clash.Annotations.TH
import Data.Kind (Type)

-- Setting the scene: mini-Barbies
data Cover = Bare | Covered
type family Wear (c :: Cover) (f :: Type -> Type) a :: Type where
    Wear Bare f a = a
    Wear Covered f a = f a

-- This one works
data Inverted c f = Inverted
    { bar' :: "FIELD1" ::: Wear c f Bool
    , baz' :: "FIELD2" ::: Wear c f Bool
    }

-- This is what `barbies-th` emits...
data Dressed c f = Dressed
    { bar2 :: Wear c f ("FIELD1" ::: Bool)
    , baz2 :: Wear c f ("FIELD2" ::: Bool)
    }

topEntity
    :: ( "FOO" ::: Inverted Covered (Signal System)
       , "BAR" ::: Dressed Covered (Signal System)
       )
topEntity =
    ( Inverted (pure True) (pure False)
    , Dressed (pure True) (pure False)
    )

makeTopEntity 'topEntity
