package body Cool_Math is

  function "+" (A, B : Position) return Position is
  begin
    return Position'(A.X + B.X, A.Y + B.Y);
  end "+";
  
  function "-" (A, B : Position) return Position is
  begin
    return Position'(A.X - B.X, A.Y - B.Y);
  end "-";
  
  function "+" (C : Circle; P : Position) return Circle is
  begin
    return Circle'(pos => C.pos + P, radius => C.radius);
  end "+";
  
  function Collides (A, B: Circle) return Boolean is
    use Scalar_Elementary;
    
    function diff (V1, V2 : Scalar) return Scalar is (abs( (V2 - V1) ));
  begin
    return Sqrt( (diff(A.pos.X, B.pos.X) ** 2.0) + (diff(A.pos.Y, B.pos.Y) ** 2.0) ) < (A.radius + B.radius);
  end Collides;

end Cool_Math;
