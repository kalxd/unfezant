module Unfezant.Engine.Color

import Data.Nat

export
data Color : Type where
    MkColor : (red : Nat)
            -> (green : Nat)
            -> (blue : Nat)
            -> (0 _ : LTE red 255)
            => (0 _ : LTE green 255)
            => (0 _ : LTE blue 255)
            => Color

sub : (a : Nat) -> (b : Nat) -> (0 prf : LT b a) => Nat
sub a 0 = a
sub (S a) (S k) {prf} = sub a k {prf=fromLteSucc prf}

checkNat : Color -> Nat
checkNat (MkColor red green blue) = sub 300 red
