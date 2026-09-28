{-# LANGUAGE CPP #-}
#if __GLASGOW_HASKELL__ >= 902
{-# LANGUAGE OverloadedRecordDot #-}
#endif

module HasFieldSpec where

import Test.Hspec (Spec)
#if __GLASGOW_HASKELL__ >= 902
import Composite.Record
import Control.Lens (set, view)
import Data.Proxy (Proxy(Proxy))
import Data.Vinyl (rcast)
import GHC.Records (HasField(getField))
import Test.Hspec (describe)
import Test.Hspec.QuickCheck (prop)
import Test.QuickCheck ((===), (.&&.))

type User = '["name" :-> String, "age" :-> Int]

type Account = '["owner" :-> Record User, "balance" :-> Double]

fAge_ :: Proxy ("age" :-> Int)
fAge_ = Proxy

nameOf :: HasField "name" r String => r -> String
nameOf r = r.name

ageOf :: (RFieldType "age" rs ~ Int, RElem ("age" :-> Int) rs) => Record rs -> Int
ageOf r = r.age

only :: Record '["x" :-> a] -> a
only r = r.x

hasFieldSuite :: Spec
hasFieldSuite =
  describe "OverloadedRecordDot" $ do
    prop "Reads back each field a Record was built with" $ \ name age ->
      let user = name :*: age :*: RNil :: Record User
       in user.name === name .&&. user.age === age

    prop "Agrees with getField and rlens" $ \ name age ->
      let user = name :*: age :*: RNil :: Record User
       in getField @"age" user === user.age .&&. view (rlens fAge_) user === user.age

    prop "Reads the value last set through rlens" $ \ name age age' ->
      let user = name :*: age :*: RNil :: Record User
       in (set (rlens fAge_) age' user).age === age'

    prop "Does not depend on field order" $ \ name age ->
      let user = name :*: age :*: RNil :: Record User
          swapped = rcast user :: Record '["age" :-> Int, "name" :-> String]
       in swapped.name === name .&&. swapped.age === age

    prop "Reads through nested records" $ \ name age balance ->
      let user = name :*: age :*: RNil :: Record User
          account = user :*: balance :*: RNil :: Record Account
       in account.owner === user .&&. account.owner.name === name .&&. account.balance === balance

    prop "Satisfies HasField constraints on records of any shape" $ \ name age userId ->
      let user = name :*: age :*: RNil :: Record User
       in nameOf user === name .&&. nameOf (userId :*: user :: Record ("id" :-> Int ': User)) === name

    prop "Works in code polymorphic in the fields of the Record" $ \ name age userId ->
      let user = name :*: age :*: RNil :: Record User
       in ageOf user === age .&&. ageOf (userId :*: user :: Record ("id" :-> Int ': User)) === age

    prop "Infers field types that are type variables" $ \ name flag ->
      only (name :*: RNil) === (name :: String) .&&. only (flag :*: RNil) === (flag :: Bool)
#else
hasFieldSuite :: Spec
hasFieldSuite = pure ()
#endif
