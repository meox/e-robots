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

  def decode(nil, _code, state), do: halt(state, "bad instruction pointer")

  def decode({:halt}, _code, state), do: state

  def decode(instruction, code, state) do
    state = exec(instruction, state)
    state = %{state | ip: state.ip + 1}
    run(code, state)
  end

  ### stack

  def exec({:pop}, state = %VM.State{:stack => []}) do
    halt(state, "pop on empty stack")
  end

  def exec({:pop}, state = %VM.State{:stack => [_ | xs]}) do
    %{state | stack: xs}
  end

  def exec({:push, x}, state = %VM.State{}) do
    %{state | stack: [x | state.stack]}
  end

  # unconditional jump
  def exec({:jump, addr}, state = %VM.State{}) do
    %{state | ip: addr}
  end

  # conditional jump
  def exec({:jump_eq, ok_addr, ko_addr}, state = %VM.State{}),
    do: exec_jump({ok_addr, ko_addr}, state, fn a, b -> a == b end)

  def exec({:jump_gt, ok_addr, ko_addr}, state = %VM.State{}),
    do: exec_jump({ok_addr, ko_addr}, state, fn a, b -> a > b end)

  def exec({:jump_gte, ok_addr, ko_addr}, state = %VM.State{}),
    do: exec_jump({ok_addr, ko_addr}, state, fn a, b -> a >= b end)

  def exec({:jump_lt, ok_addr, ko_addr}, state = %VM.State{}),
    do: exec_jump({ok_addr, ko_addr}, state, fn a, b -> a < b end)

  def exec({:jump_lte, ok_addr, ko_addr}, state = %VM.State{}),
    do: exec_jump({ok_addr, ko_addr}, state, fn a, b -> a <= b end)

  # function call
  # def exec({:call, addr, params}, state = %VM.State{}) do
  # end

  # memory
  def exec({:fetch, region, addr}, state = %VM.State{}) do
    case Map.get(state.memory, {region, addr}) do
      nil ->
        halt(state, "invalid memory address: {region: #{region}, addr: #{addr}}")

      v ->
        exec({:push, v}, state)
    end
  end

  def exec({:store, region, addr}, state = %VM.State{:stack => [x | xs]}) do
    %{state | memory: Map.put(state.memory, {region, addr}, x), stack: xs}
  end

  ### OS

  def exec({:print}, state = %VM.State{:stack => [x | xs]}) do
    IO.puts(x)
    %{state | stack: xs}
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

  # private

  defp exec_jump({ok_addr, ko_addr}, state = %VM.State{:stack => [a, b | xs]}, f) do
    if f.(a, b) do
      %{state | ip: ok_addr, stack: xs}
    else
      %{state | ip: ko_addr, stack: xs}
    end
  end

  defp halt(state, reason) do
    %{state | valid: false, desc: reason}
  end
end
