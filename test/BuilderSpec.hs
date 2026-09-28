{-# LANGUAGE CPP #-}
#if __GLASGOW_HASKELL__ >= 900
{-# LANGUAGE QualifiedDo #-}
#endif
#if __GLASGOW_HASKELL__ < 910
{-# OPTIONS_GHC -Wno-unused-do-bind #-}
#endif

module BuilderSpec where

import Test.Hspec (Spec)
#if __GLASGOW_HASKELL__ >= 900
import Composite.Record
import qualified Composite.Record.Builder as R
import Data.Functor.Const (Const(Const))
import Test.Hspec (describe)
import Test.Hspec.QuickCheck (prop)
import Test.QuickCheck ((===))

type User = '["name" :-> String, "age" :-> Int]

type Admin = '["name" :-> String, "age" :-> Int, "admin" :-> Bool]

builderSuite :: Spec
builderSuite =
  describe "Record builder" $ do
    prop "Builds the same record as :*:" $ \ name age admin ->
      let built :: Record Admin
          built = R.do
            R.field @"name" name
            R.field @"age" age
            R.field @"admin" admin
       in built === (name :*: age :*: admin :*: RNil)

    prop "Builds a single field record from one statement" $ \ name ->
      let built :: Record '["name" :-> String]
          built = R.do
            R.field @"name" name
       in built === (name :*: RNil)

    prop "Splices existing records in order" $ \ name age admin ->
      let user = name :*: age :*: RNil :: Record User
          built :: Record Admin
          built = R.do
            user
            R.field @"admin" admin
       in built === (name :*: age :*: admin :*: RNil)

    prop "Builds records over Maybe" $ \ name age ->
      let built :: Rec Maybe User
          built = R.do
            name :^: RNil
            age :^: RNil
       in built === (name :^: age :^: RNil)

    prop "Builds records over Const" $ \ nameLabel ageLabel ->
      let built :: Rec (Const String) User
          built = R.do
            Const nameLabel :& RNil
            Const ageLabel :& RNil
       in built === (Const nameLabel :& Const ageLabel :& RNil)
#else
builderSuite :: Spec
builderSuite = pure ()
#endif
