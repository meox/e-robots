defmodule VM.Test do
  use ExUnit.Case

  test "add" do
    state =
      VM.run([
        {:push, 5},
        {:push, 7},
        {:add}
      ])

    assert state.stack == [12]
  end

  test "push & pop" do
    state =
      VM.run([
        {:push, 5},
        {:pop}
      ])

    assert state.stack == []
  end

  test "pop empty stack" do
    state =
      VM.run([
        {:pop}
      ])

    assert state.stack == []
    assert state.valid == false
  end
end
