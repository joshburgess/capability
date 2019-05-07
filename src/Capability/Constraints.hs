{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeInType #-}
{-# LANGUAGE TypeOperators #-}

-- | This module define helper types and type families for working with sets of
-- capabilities.

module Capability.Constraints
  ( All
  , Constraint
  , Dict(..)
  , None
  ) where

import Data.Kind (Constraint)

-- | Evidence of a constraint that can be passed around as a value. Matching on
-- the constructor brings the constraint into scope.
--
-- This is similar to the @Dict@ datatype defined in the @constraints@ package,
-- but redefined here to avoid the dependence.
data Dict (c :: Constraint) = c => Dict

-- | Type family used used to apply a list of capabilities to a single type.
--
-- Examples:
--
-- > All '[Num, Eq] Int
-- >   -- Equivalent to: (Num Int, Eq Int)
-- >
-- > All '[HasReader "foo" Int, HasStream "bar" Float] m
-- >   -- Equivalent to: (HasReader "foo" Int m, HasStream "bar" Float m)
type family All (xs :: [k -> Constraint]) a :: Constraint where
  All '[] a = ()
  All (x ':xs) a = (x a, All xs a)

-- | Convenient type synonym representing an empty set of capabilities.
--
-- This is useful, because GHC infers @'[]@ as being of kind @[*]@ without an
-- extra kind annotation.
type None = ('[] :: [k -> Constraint])