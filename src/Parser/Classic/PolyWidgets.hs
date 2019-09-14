module Parser.Classic.PolyWidgets
  ( parsePolyWidget
  ) where

import Ast ( PolyWidget(..) )

import qualified Parser.Classic.Words as W
  ( Keywords(ForAll, SuchThat, Where) )

import Parser.Classic.Exprs ( parseExpr )
import Parser.Classic.Idents ( parseIdent )
import Parser.Common ( prefix, stoken )
import Parser.Types ( Parser, parseTypeObject )

import Text.ParserCombinators.ReadP ( ReadP, choice )

parsePolyWidget :: Parser -> ReadP PolyWidget
parsePolyWidget p = choice
  [ parseForAll
  , parseSuchThat p
  , parseWhere p
  ]

parseForAll :: ReadP PolyWidget
parseForAll = prefix ForAll (W.ForAll) parseIdent

parseWhere :: Parser -> ReadP PolyWidget
parseWhere p = prefix Where (W.Where) $ do
  ident <- parseIdent
  stoken "<-"
  expr <- parseExpr p
  return (ident, expr)

parseSuchThat :: Parser -> ReadP PolyWidget
parseSuchThat p = prefix SuchThat (W.SuchThat) $ do
  ident <- parseIdent
  stoken "*>"
  to <- parseTypeObject p
  return (ident, to)
