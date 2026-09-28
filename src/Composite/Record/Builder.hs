-- |Build records with @QualifiedDo@, one field per line.
--
-- Import this module qualified, then each statement of a qualified do block is a record and the block appends them in order:
--
-- @
--   import qualified Composite.Record.Builder as R
--
--   alice :: 'Record' '["name" :-> String, "age" :-> Int, "admin" :-> Bool]
--   alice = R.do
--     R.field \@"name" "alice"
--     R.field \@"age" 42
--     R.field \@"admin" True
-- @
--
-- A statement can be any record of the same functor, so an existing record can be spliced in:
--
-- @
--   promote :: 'Record' '["name" :-> String, "age" :-> Int] -> 'Record' '["name" :-> String, "age" :-> Int, "admin" :-> Bool]
--   promote user = R.do
--     user
--     R.field \@"admin" True
-- @
--
-- Fields are appended in the order written, so use 'Data.Vinyl.rcast' to build a record whose fields are declared in a different order.
--
-- Before GHC 9.10, @-Wunused-do-bind@ (part of @-Wall@) warns about every statement but the last, so turn it off with @-Wno-unused-do-bind@ in modules that use the builder.
module Composite.Record.Builder
  ( (>>)
  , field
  ) where

import Prelude hiding ((>>))
import Composite.Record (Rec((:&), RNil), Record, (:->), val)
import Data.Vinyl (rappend)
import Data.Vinyl.TypeLevel (type (++))

-- |Append two records, which is how a qualified do block joins its statements.
(>>) :: Rec f as -> Rec f bs -> Rec f (as ++ bs)
(>>) = rappend
{-# INLINE (>>) #-}

-- |A record with the single field @s@, for one line of a builder block. Not to be confused with 'Composite.CoRecord.field', which makes a 'Composite.CoRecord.Field'.
field :: forall s a. a -> Record '[s :-> a]
field a = val @s a :& RNil
{-# INLINE field #-}
