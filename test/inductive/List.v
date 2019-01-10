(**
    RUN: %coqc %s
    RUN: %machcoq List.json -o %t.cpp
    RUN: FileCheck %s -check-prefix=CPP < %t.cpp
    RUN: %clang -c %t.cpp
    RUN: %clean

    Library declaration
    CPP: #include "variant.hpp"
    CPP: using namespace Variant;

    Base types
    CPP: struct Nil {};
    CPP: template<{{class}} [[TT:.?]]>
    CPP: struct Cons {
    CPP: [[TT]] [[AA:.?]];
    CPP: std::shared_ptr<std::variant<Nil, Cons<[[TT]]>>> [[BB:.?]];
    CPP: Cons([[TT]] [[AA]], std::shared_ptr<std::variant<Nil, Cons<[[TT]]>>> [[BB]]) {
    CPP: this->[[AA]] = [[AA]];
    CPP: this->[[BB]] = [[BB]];
    CPP: }

    Type alias for sum type
    CPP: template<class [[TT]]>
    CPP: using coq_List = std::variant<Nil, Cons<[[TT]]>>

    Coq constructor functions
    CPP: template<class [[TT]]>
    CPP: std::shared_ptr<coq_List<[[TT]]>> nil()
    CPP: return std::make_shared<coq_List<[[TT]]>>(Nil());
    CPP: template<class [[TT]]>
    CPP: std::shared_ptr<coq_List<[[TT]]>> cons([[TT]] [[AA]], std::shared_ptr<coq_List<[[TT]]>> [[BB]])
    CPP: return std::make_shared<coq_List<[[TT]]>>(Cons([[AA]], [[BB]]));

    Match definition
    CPP: template<class [[TT]], class [[UU:.?]], class [[VV:.?]]>
    CPP: match(std::shared_ptr<coq_List<[[TT]]>> self, [[UU]] f, [[VV]] g)
    CPP: return gmatch(self, [=](Nil a) { return f(); }, [=](Cons<[[TT]]> a) { return g(a.[[AA]], a.[[BB]]); });
    CPP: }
*)


Inductive list (A : Type) : Type :=
 | nil : list A
 | cons : A -> list A -> list A.

Require Extraction.
Extraction Language JSON.
Separate Extraction list.