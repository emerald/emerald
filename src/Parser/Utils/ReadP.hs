{-# LANGUAGE DeriveGeneric #-}
-----------------------------------------------------------------------------
-- |
-- Copyright   :  (c) Oleks Shturmov, 2020-2021
-- License     :  BSD 3-Clause (see the file LICENSE)
--
-- Maintainer  :  oleks@oleks.info
-----------------------------------------------------------------------------
module Parser.Utils.ReadP
  ( ParseErrorImpl
  , fullParse, parse
  , optCommaList, commaList
  , inBrackets
  , prefix, prefixInfix
  , skipFilling, stoken, stoken1, stoken1Bool
  , token, token1
  , word, word1
  , parseFile', parseString'
  ) where

import Data.Char (isSpace, toUpper, toLower)
import Data.List.NonEmpty (NonEmpty((:|)), toList)
import Control.Applicative (liftA2)
import Control.Monad (void)
import Text.ParserCombinators.ReadP
  ( ReadP
  , eof, get, look
  , between, char, choice, eof
  , many, manyTill, option
  , pfail, satisfy
  , readP_to_S
  )
import Text.PrettyPrint.GenericPretty (Generic, Out)

data ParseErrorImpl a
  = NoParse FilePath
  | AmbiguousGrammar [a] FilePath
  | NotImplemented
  deriving (Eq, Generic, Ord, Show)

instance (Out a) => Out (ParseErrorImpl a)

string :: String -> ReadP String
-- ^ Case-insensitive variant of ReadP's string
string this = do s <- look; scan this s
 where
  scan []     _               = do return this
  scan (x:xs) (y:ys)
    | x == (toLower y) || x == (toUpper y)
    = do _ <- get; scan xs ys
  scan _      _               = do pfail

anyChar :: ReadP Char
anyChar = satisfy (\ _ -> True)

anyLine :: ReadP ()
anyLine = void $ manyTill anyChar (char '\n')

-- | Skip comments and whitespace
skipFilling :: ReadP ()
skipFilling =
  do s <- look
     skip s
 where
  skip ('%':_)           = anyLine >> skipFilling
  skip (c:s) | isSpace c = do _ <- get; skip s
  skip _                 = do return ()

-- | Skip at least one comment or whitespace
skip1Filling :: ReadP ()
skip1Filling = do
  s <- look
  case s of
    ('%':_)           -> anyLine >> skipFilling
    (c:_) | isSpace c -> do _ <- get; skipFilling
    _                 -> pfail

-- | Skip comments and whitespace after token
token :: ReadP a -> ReadP a
token = flip (<*) skipFilling

-- | Skip at least one comment or whitespace after token
token1 :: ReadP a -> ReadP a
token1 = flip (<*) $ choice [ skip1Filling, eof ]

-- | Skip comments and whitespace after string token
stoken :: String -> ReadP ()
stoken = void . token . string

stoken1 :: String -> ReadP ()
stoken1 = void . token1 . string

stoken1Bool :: String -> ReadP Bool
stoken1Bool s = option False ((stoken1 s) *> return True)

word :: [(String, a)] -> ReadP a
word = choice . map (\(w, a) -> stoken w *> return a)

word1 :: [(String, a)] -> ReadP a
word1 = choice . map (\(w, a) -> stoken1 w *> return a)

prefix :: Show w => (a -> b) -> w -> ReadP a -> ReadP b
prefix f w p = stoken1 (show w) *> fmap f p

prefixInfix :: Show w =>
  (a -> a -> b) -> w -> w -> ReadP a -> ReadP b
prefixInfix f w1 w2 p
  = stoken1 (show w1) *> fmap f p <* stoken1 (show w2) <*> p

commaList :: ReadP a -> ReadP (NonEmpty a)
commaList p = liftA2 (:|) p (many (stoken "," *> p))

optCommaList :: ReadP a -> (ReadP [a] -> ReadP [a]) -> ReadP [a]
optCommaList p opt = choice
  [ opt (fmap toList $ commaList p)
  , return []
  ]

inBrackets :: ReadP a -> ReadP a
inBrackets = between (stoken "[") (stoken "]")

parse :: ReadP a -> String -> [(a, String)]
parse = readP_to_S

fullParse :: ReadP a -> String -> [a]
fullParse p s = fmap fst $ parse (p <* eof) s

parseString' :: ReadP a -> FilePath -> String -> Either (ParseErrorImpl a) a
parseString' p path s =
  case fullParse p s of
    [] -> Left $ NoParse path
    [a] -> Right a
    as -> Left $ AmbiguousGrammar as path

parseFile' :: ReadP a -> FilePath -> IO (Either (ParseErrorImpl a) a)
parseFile' p path = fmap (parseString' p path) $ readFile path
