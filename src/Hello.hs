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

-- This is what `barbies-th` emits...
data Dressed c f = Dressed
    { fd1' :: Wear c f ("FIELD1" ::: Bool)
    , fd2' :: Wear c f ("FIELD2" ::: Bool)
    }

-- This one works
data Inlined f = Inlined
    { fd1 :: f ("FIELD1" ::: Bool)
    , fd2 :: f ("FIELD2" ::: Bool)
    }

topEntity
    :: ( "FOO" ::: Dressed Covered (Signal System)
       , "BAR" ::: Inlined (Signal System)
       )
topEntity =
    ( Dressed (pure True) (pure False)
    , Inlined (pure True) (pure False)
    )

makeTopEntity 'topEntity
