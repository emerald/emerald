-----------------------------------------------------------------------------
-- |
-- Copyright   :  (c) Oleks Shturmov, 2020-2021
-- License     :  BSD 3-Clause (see the file LICENSE)
--
-- Maintainer  :  oleks@oleks.info
-----------------------------------------------------------------------------
module Parser.Classic.ReadP.Test.Types (testTree) where

import Parser.Utils.ReadP (parse)
import Parser.Classic.ReadP.Types (parseType)

import Parser.Classic.Gen.Types (ValidType(..), InvalidType(..))

import Test.Tasty (TestTree, testGroup)
import Test.Tasty.QuickCheck (Property, (===), testProperty)

prop_validType :: ValidType -> Property
prop_validType (ValidType (s, e)) = parse parseType s === [(e, "")]

prop_invalidType :: InvalidType -> Property
prop_invalidType (InvalidType s) = parse parseType s === []

testTree :: IO TestTree
testTree = fmap (testGroup "ClassicTypesTests") $ sequence
  [ return $ testProperty
      "Valid types parse"
      prop_validType
  , return $ testProperty
      "Invalid types don't parse"
      prop_invalidType
  ]
