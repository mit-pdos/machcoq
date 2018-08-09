{-# LANGUAGE RecordWildCards, OverloadedStrings  #-}
module PrettyPrinter.Expr where
import Codegen.Expr
import Codegen.Utils
import Codegen.Rewrite
import PrettyPrinter.Defs
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Char as C
import Data.Text.Prettyprint.Doc
import Data.Text.Prettyprint.Doc.Render.Text

instance Pretty CExpr where
  pretty CExprLambda  { .. } = group $ "[=](" <> commatize _largs
                             <> ") {"
                             <+> "return" <+> pretty _lbody <> ";"
                             <+> "}"
  pretty CExprCall    { _fname = "Coq_ret", .. } = group $ "return" <+> hsep (map pretty _fparams)
  pretty CExprCall    { _fname = "Nat.eqb", _fparams = [a, b] } = (pretty a) <+> "==" <+> (pretty b)
  pretty CExprCall    { .. } = group $ pretty (toCName _fname) <> "(" <> breakcommatize _fparams <> ")"
  pretty CExprVar     { .. } = pretty _var
  pretty CExprStr     { .. } = "\"" <> pretty _str <> "\""
  pretty CExprNat     { .. } = "(Nat)" <> pretty _nat
  pretty CExprBool    { .. } = pretty _bool
  pretty CExprList    { .. } = "List<T>{" <> commatize _elems <> "}"
  pretty CExprCtor    { .. } = commatize _cargs
  pretty CExprTuple   { .. } = group (parens . breakcommatize $ _items)
  pretty CExprStmt    { _stype = "auto", _sname = "_", .. } = pretty _sbody
  pretty CExprStmt    { .. } = pretty _stype <+> pretty _sname <+> "=" <+> pretty _sbody
  pretty CExprSeq     { .. } = pretty _left <> ";" <> line <> pretty _right
  pretty CExprWild     {}    = "Otherwise"
