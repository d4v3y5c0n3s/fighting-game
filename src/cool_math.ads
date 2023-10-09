package Cool_Math is

  type Scalar is delta 10.0 ** (-6) digits 13;
  
  type Position is record
    X : Scalar := 0.0;
    Y : Scalar := 0.0;
  end record;
  
  type Circle is record
    pos : Position;
    radius : Scalar;
  end record;
  
  function "+" (A, B : Position) return Position;

end Cool_Math;
