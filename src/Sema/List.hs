{-# LANGUAGE OverloadedStrings  #-}
module Sema.List where
import Common.Flatten
import CIR.Expr
import Data.Maybe

-- List semantics, ie:
--   * cons(1, cons(2, cons(3, []))) = [1,2,3]
--   * cons(1, cons(add 2 3, []) = [1, 2 + 3]
--   * foo :: Nat -> List Nat
--   * cons(1, cons(2, foo n)) = [1, 2] ++ foo n
listSemantics :: CExpr -> CExpr
listSemantics c = case deconstruct c of
    -- All of list unrolled successfully
    (l,  Nothing) -> CExprList freeT $ map listSemantics l
    -- Some expression remained, do not use append haphazardly
    ([a], Just e) -> CExprCall "cons" [listSemantics a, descend listSemantics e]
    ([],  Just e) -> descend listSemantics e
    (l,   Just e) -> CExprCall "app" [CExprList freeT $ map listSemantics l, descend listSemantics e]
    where freeT = CTFree 1 -- CTUndef -- TODO: Infer the type
          deconstruct CExprCall { _fname = "Datatypes.Coq_cons", _fparams = [a, b] } =
              case deconstruct b of
                (ls, Just bb) -> (a:ls, snd . deconstruct $ bb)
                (ls, Nothing) -> (a:ls, Nothing)
          deconstruct CExprCall { _fname = "Datatypes.Coq_nil", _fparams = [] } = ([], Nothing)
          deconstruct CExprCall { .. }
		  	  | _fname == "Datatypes.Coq_nil" ||
				_fname == "Datatypes.Coq_cons" = error "List constructors with the wrong number of arguments"
          deconstruct other = ([], Just other)
