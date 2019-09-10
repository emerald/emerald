module Parser.Classic.Objects
  ( parseObject
  ) where

import Ast (Object(..), BlockBody)
import Parser.Common (stoken, stoken1, stoken1Bool)
import Parser.Classic.Idents (parseIdent)
import Parser.Classic.BlockBody (parseBlockBody)
import Parser.Types (Parser, parseAttDecl)

import qualified Parser.Classic.Words as W
  ( Keywords(Object, End, Initially, Immutable, Monitor, Process, Recovery) )

import Control.Monad (void)
import Text.ParserCombinators.ReadP
  ( ReadP
  , choice, many
  , pfail
  )

parseObject :: Parser -> ReadP Object
parseObject p = do
  immutable <- stoken1Bool (show W.Immutable)
  monitor <- stoken1Bool (show W.Monitor)
  name <- (stoken1 (show W.Object) *> parseIdent)
  decls <- many (parseAttDecl p)
  (initially, process, recovery) <- parseTail
    ( parseInitially p
    , parseProcess p
    , parseRecovery p
    , (Nothing, Nothing, Nothing)
    )
  void (stoken1 (show W.End) >> stoken name)
  return $ Object immutable monitor
    name decls initially process recovery

data ObjectTail
  = Initially BlockBody
  | Process BlockBody
  | Recovery BlockBody
  | NoTail
  deriving (Eq, Ord)

parseTail :: (ReadP BlockBody, ReadP BlockBody, ReadP BlockBody,
              (Maybe BlockBody, Maybe BlockBody, Maybe BlockBody))
             -> ReadP (Maybe BlockBody, Maybe BlockBody, Maybe BlockBody)
parseTail (p1, p2, p3, r @ (r1, r2, r3)) = do
  b <- choice
    [ fmap Initially  p1
    , fmap Process    p2
    , fmap Recovery   p3
    , return NoTail
    ]
  case b of
    (Initially  b') -> parseTail (pfail, p2, p3, (Just b', r2, r3))
    (Process    b') -> parseTail (p1, pfail, p3, (r1, Just b', r3))
    (Recovery   b') -> parseTail (p1, p2, pfail, (r1, r2, Just b'))
    NoTail          -> return r

parseBlock :: Show w => w -> Parser -> ReadP BlockBody
parseBlock w p =
  stoken1 (show w) *>
  parseBlockBody p <*
  stoken1 (show W.End) <*
  stoken1 (show w)

parseInitially :: Parser -> ReadP BlockBody
parseInitially = parseBlock W.Initially

parseProcess :: Parser -> ReadP BlockBody
parseProcess = parseBlock W.Process

parseRecovery :: Parser -> ReadP BlockBody
parseRecovery = parseBlock W.Recovery
