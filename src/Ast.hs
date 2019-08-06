module Ast where

type Ident
  = String

data Type
  = TInt
  | TChar
  | TDouble
  | TString
  deriving (Eq, Ord, Show)

data Lit
  = LInt Int
  | LDouble Double
  | LChar Char
  | LString String
  | LBool Bool
  | LNil
  deriving (Eq, Ord, Show)

data Object
  = Object Ident [(Bool, Decl)]
  deriving (Eq, Ord, Show)

data Expr
  = ELit Lit
  | EVar Ident
  | EObj Object
  | ETimes Expr Expr
  | EDiv Expr Expr
  | EMod Expr Expr
  | EPlus Expr Expr
  | EMinus Expr Expr
  | EEq Expr Expr
  | ENeq Expr Expr
  | ELt Expr Expr
  | ELeq Expr Expr
  | EGt Expr Expr
  | EGeq Expr Expr
  deriving (Eq, Ord, Show)

newtype ConstDecl
  = Const (Ident, (Maybe Type), Expr)
  deriving (Eq, Ord, Show)

newtype VarDecl
  = Var (Ident, [Ident], (Maybe Type), Expr)
  deriving (Eq, Ord, Show)

data Decl
  = DConst ConstDecl
  | DVar VarDecl
  deriving (Eq, Ord, Show)

type Compilation = [ConstDecl]
