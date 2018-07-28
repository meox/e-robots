defmodule VM do
  @doc """

  """

  def run(_code, _state \\ %VM.State{})
  def run(_code = [], state), do: state

  def run(code, state) when is_list(code) do
    Enum.at(code, state.ip)
    |> decode(code, state)
  end

  ###

  def decode(nil, _code, state), do: %{state | valid: false, desc: "bad instruction pointer"}

  def decode({:halt}, _code, state), do: state

  def decode(instruction, code, state) do
    state = exec(instruction, state)
    state = %{state | ip: state.ip + 1}
    run(code, state)
  end

  ### instruction

  def exec({:pop}, state = %VM.State{:stack => []}) do
    %{state | valid: false, desc: "pop on empty stack"}
  end

  def exec({:pop}, state = %VM.State{:stack => [_ | xs]}) do
    %{state | stack: xs}
  end

  def exec({:push, x}, state = %VM.State{}) do
    %{state | stack: [x | state.stack]}
  end

  ### math opcode

  def exec({:add}, state), do: exec_math_duo(state, &(&1 + &2))
  def exec({:mul}, state), do: exec_math_duo(state, &(&1 * &2))
  def exec({:div}, state), do: exec_math_duo(state, &(&1 / &2))
  def exec({:rem}, state), do: exec_math_duo(state, &rem(&1, &2))
  def exec({:sin}, state), do: exec_math_unary(state, &:math.sin(&1))
  def exec({:cos}, state), do: exec_math_unary(state, &:math.cos(&1))
  def exec({:tan}, state), do: exec_math_unary(state, &:math.tan(&1))

  def exec_math_duo(state = %VM.State{:stack => [a, b | xs]}, fun) do
    %{state | stack: [fun.(a, b) | xs]}
  end

  def exec_math_unary(state = %VM.State{:stack => [x | xs]}, fun) do
    %{state | stack: [fun.(x) | xs]}
  end
end
