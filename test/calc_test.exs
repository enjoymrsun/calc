defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "Test Calculator" do
    assert Calc.eval("((10+45/5*20-21*(4-(3))*((20/5)))-1*(3+16))") == 87
    assert Calc.eval("5*4/2+5*(14-7)*2-3/2*10+11-6*2") == 69
    assert Calc.eval("5*6/2+5*(10-7)*2-6/2*10+10-6*2+3") == 16
  end
end
