{-# OPTIONS_GHC -fno-warn-redundant-constraints #-}
{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE QuantifiedConstraints #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators #-}

module Capability.Context where

import Capability.Constraints
import Data.Coerce (Coercible)
import Unsafe.Coerce (unsafeCoerce)

-- | Execute the given action with an additional @inner@ capability derived from
-- current context via the @t@ wrapper, retaining the list @cs@ of capabilities.
context ::
  forall t (derived :: [Capability]) (ambient :: [Capability]) m a.
  ( forall x. Coercible (t m x) (m x)
  , All derived (t m)
  , All ambient m)
  => (forall m'. (All derived m', All ambient m') => m' a) -> m a
context action =
  let tmDict = Dict @(All derived (t m))
      mDict =
        -- Note: this use of 'unsafeCoerce' should be safe thanks the Coercible
        -- constraint between 'm x' and 't m x'. However, dictionaries
        -- themselves aren't coercible since the type role of 'c' in 'Dict c' is
        -- nominal.
        unsafeCoerce @_ @(Dict (All derived m)) tmDict in
  case mDict of
    Dict -> action
{-# INLINE context #-}
