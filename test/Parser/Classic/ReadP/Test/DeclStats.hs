module Parser.Classic.ReadP.Test.DeclStats (testTree) where

import Parser.Classic.ReadP ( parser )
import Parser.Classic.ReadP.DeclStats ( parseDeclStats )
import Parser.Classic.ReadP.Test.Golden ( goldenTestAll )

import Test.Tasty (TestTree, testGroup)

testTree :: IO TestTree
testTree = fmap (testGroup "ClassicDeclStatsTests") $ sequence
  [ goldenTests
  ]

goldenTests :: IO TestTree
goldenTests = goldenTestAll p ["DeclStats"]
  where p = parseDeclStats parser
