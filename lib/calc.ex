defmodule Calc do
  @moduledoc """
  Documentation for Calc.
  """

  defp is_digit(n) do
    digit_list = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    Enum.member?(digit_list, n)
  end

  defp get_type(s) do
    cond do
      s == " " -> 0
      is_digit(s) -> 1
      s == "(" -> 2
      s == ")" -> 3
      true -> 4
    end
  end

  defp eval_num(sign, num, stack1) do
    new_num = num
    new_stack = stack1
    case sign do
      "+" -> new_num = num
      "-" -> new_num = -num
      "*" ->
        t_num = elem(stack1, 0)
        new_num = t_num * num
        new_stack = Tuple.delete_at(stack1, 0)
      "/" ->
        new_num = stack1
        |> elem(0)
        |> div(num)
        new_stack = Tuple.delete_at(stack1, 0)
    end
    Tuple.insert_at(new_stack, 0, new_num)
  end

  defp eval_helper_one(char_list, num, sign, stack1, stack2) do
    e_first = List.first(char_list)
    cond do
      e_first == nil -> eval_num(sign, num, stack1)
      true -> eval_helper_two(char_list, num, sign, stack1, stack2)
    end
  end

  defp eval_helper_two(char_list, num, sign, stack1, stack2) do
    e_first = List.first(char_list)
    type = get_type(e_first)
    new_list = List.delete_at(char_list, 0)
    new_num = num
    new_sign = sign
    new_stack_1 = stack1
    new_stack_2 = stack2
    case type do
      0 -> :ok
      1 -> new_num = num * 10 + String.to_integer(e_first)
      2 ->
        new_stack_1 = Tuple.insert_at(stack1, 0, e_first)
        new_stack_2 = Tuple.insert_at(stack2, 0, sign)
        new_sign = "+"
      3 ->
        stack1 = eval_num(sign, num, stack1)
        idx = stack1
        |> Tuple.to_list
        |> Enum.find_index(&(&1 == "("))
        new_num = stack1
        |> Tuple.to_list
        |> Enum.slice(0, idx)
        |> Enum.sum
        {_, stack1} = Enum.split(Tuple.to_list(stack1), idx+1)
        new_stack_1 = List.to_tuple(stack1)
        new_sign = elem(stack2, 0)
        new_stack_2 = Tuple.delete_at(stack2, 0)
      4 ->
        new_stack_1 = eval_num(sign, num, stack1)
        new_num = 0
        new_sign = e_first
    end
    eval_helper_one(new_list, new_num, new_sign, new_stack_1, new_stack_2)
  end

  @doc """
  Evaluate the string input into an integer result.

  ## Examples

    iex> 34*10-4*(-6*3+10)
    372
    iex> 5*(-10) * 10 +712-30*12
    -148
    iex> 5* 3+ 10-(-10*2)
    45

  """
  def eval(str) do
    str
    |> String.trim
    |> String.codepoints
    |> eval_helper_one(0, "+", {}, {})
    |> Tuple.to_list
    |> Enum.sum
  end

  def main() do
    case IO.gets("Input Formula: ") do
      :eof ->
        IO.puts "All done."
      {:error, reason} ->
        IO.puts "Error: #{reason}."
      line ->
        IO.puts eval(line)
        main()
    end
  end
end
