-----------------------------------------------------------------------------
-- |
-- Copyright   :  (c) Oleks Shturmov, 2020-2021
-- License     :  BSD 3-Clause (see the file LICENSE)
--
-- Maintainer  :  oleks@oleks.info
-----------------------------------------------------------------------------
module Parser.Classic.ReadP.Operations
  ( parseOperation
  ) where

import Ast (Operation(..), OpSig(..))

import qualified Parser.Classic.Words as W
  ( Keywords( Export ) )

import Parser.Classic.ReadP.BlockBody ( parseBlockBody )
import Parser.Classic.ReadP.Common ( end )
import Parser.Classic.ReadP.OpSigs ( parseOpSig )
import Parser.Utils.ReadP ( stoken1Bool )
import Parser.Types ( Parser )

import Text.ParserCombinators.ReadP ( ReadP )

parseOperation :: Parser -> ReadP Operation
parseOperation p = do
  export <- stoken1Bool (show W.Export)
  opsig <- parseOpSig p
  body <- parseBlockBody p
  let OpSig (_, name, _, _, _) = opsig
  end name
  return $ Operation (export, opsig, body)
