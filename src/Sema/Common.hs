{-# LANGUAGE RecordWildCards #-}
module Sema.Common where
import Codegen.Expr

-- Propagate to children expr
descend :: (CExpr -> CExpr) -> CExpr -> CExpr
descend f c@CExprCall   { .. } = f c
descend f   CExprStmt   { .. } = CExprStmt _stype _sname (descend f _sbody)
descend f   CExprLambda { .. } = CExprLambda _largs (f _lbody)
descend f   CExprCase   { .. } = CExprCase (f _cexpr) (map f _cases)
descend f   CExprMatch  { .. } = CExprMatch (f _mpat) (f _mbody)
descend f   CExprTuple  { .. } = CExprTuple (map f _items)
descend f   CExprList   { .. } = CExprList $ map (descend f) _elems
-- If it doesn't match anything, then it's a normal form, ignore
descend f   other              = other