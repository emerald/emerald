module Parser.Classic.Test.Loops (testTree) where

import Parser.Classic ( parser )
import Parser.Classic.Loops ( parseLoop )
import Parser.TestCommon ( goldenTestAll )

import Test.Tasty (TestTree, testGroup)

testTree :: IO TestTree
testTree = fmap (testGroup "ClassicLoopTests") $ sequence
  [ goldenTests
  ]

goldenTests :: IO TestTree
goldenTests = goldenTestAll p ["Loop"]
  where p = parseLoop parser
