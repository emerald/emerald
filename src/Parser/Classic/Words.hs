-----------------------------------------------------------------------------
-- |
-- Module      :  TEmPLE.Parser.ClassicAttached
-- Copyright   :  (c) Oleks Shturmov
-- License     :  BSD 3-Clause (see the file LICENSE)
--
-- Maintainer  :  oleks@oleks.info
--
-- A module listing the reserved words in classical Emerald.
--
-- Classical Emerald makes a distinction between reserved literals
-- (e.g., `nil`) and keywords (e.g., `object`) — so do we.

module Parser.Classic.Words
  ( Keywords(..)
  , Literals(..)
  , literals, keywords, reserved
  ) where

import Prelude hiding (True, False)

data Literals
  = Nil
  | Self
  | True
  | False
  deriving (Bounded, Enum)

instance Show Literals where
  show Nil   = "nil"
  show Self  = "self"
  show True  = "true"
  show False = "false"

allLiterals :: [Literals]
allLiterals = [minBound..maxBound]

-- | The list of reserved literals.
literals :: [String]
literals = map show allLiterals

data Keywords
  = And
  | As
  | Assert
  | At
  | Attached
  | Awaiting
  | Begin
  | By
  | Checkpoint
  | CodeOf
  | Const
  | Else
  | ElseIf
  | End
  | Exit
  | Failure
  | For
  | Fix
  | If
  | Initially
  | IsFixed
  | IsLocal
  | Locate
  | Loop
  | Move
  | NameOf
  | Object
  | Or
  | Process
  | Recovery
  | Refix
  | Restrict
  | Return
  | ReturnAndFail
  | Signal
  | SynTypeOf
  | Then
  | To
  | TypeOf
  | Unavailable
  | Unfix
  | Var
  | View
  | Wait
  | When
  | While
  deriving (Bounded, Enum)

instance Show Keywords where
  show And       = "and"
  show As        = "as"
  show Assert    = "assert"
  show At        = "at"
  show Attached  = "attached"
  show Awaiting  = "awaiting"
  show Begin     = "begin"
  show By        = "by"
  show Checkpoint = "checkpoint"
  show Const     = "const"
  show CodeOf    = "codeof"
  show Else      = "else"
  show ElseIf    = "elseif"
  show End       = "end"
  show Exit      = "exit"
  show Failure   = "failure"
  show Fix       = "fix"
  show For       = "for"
  show If        = "if"
  show Initially = "initially"
  show IsFixed   = "isfixed"
  show IsLocal   = "islocal"
  show Locate    = "locate"
  show Loop      = "loop"
  show Move      = "move"
  show NameOf    = "nameof"
  show Object    = "object"
  show Or        = "or"
  show Process   = "process"
  show Recovery  = "recovery"
  show Refix     = "refix"
  show Restrict  = "restrict"
  show Return    = "return"
  show ReturnAndFail = "returnandfail"
  show Signal    = "signal"
  show SynTypeOf = "syntactictypeof"
  show Then      = "then"
  show To        = "to"
  show TypeOf    = "typeof"
  show Unavailable = "unavailable"
  show Unfix     = "unfix"
  show Var       = "var"
  show View      = "view"
  show Wait      = "wait"
  show When      = "when"
  show While     = "while"

allKeywords :: [Keywords]
allKeywords = [minBound..maxBound]

-- | The list of reserved keywords.
keywords :: [String]
keywords = map show allKeywords

-- | The complete list of reserved words.
reserved :: [String]
reserved = literals ++ keywords
