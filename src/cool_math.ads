with Ada.Numerics.Generic_Elementary_Functions;

package Cool_Math is

  type Scalar is digits 13;

  package Scalar_Elementary is new Ada.Numerics.Generic_Elementary_Functions(Scalar);
  
  type Position is record
    X : Scalar := 0.0;
    Y : Scalar := 0.0;
  end record;
  
  type Circle is record
    pos : Position;
    radius : Scalar;
  end record;
  
  function "+" (A, B : Position) return Position;
  
  function "-" (A, B : Position) return Position;
  
  function "+" (C : Circle; P : Position) return Circle;
  
  function Collides (A, B: Circle) return Boolean;

end Cool_Math;
