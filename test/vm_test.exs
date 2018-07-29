defmodule VM.Test do
  use ExUnit.Case

  test "add" do
    state =
      VM.run([
        {:push, 5},
        {:push, 7},
        {:add},
        {:halt}
      ])

    assert state.stack == [12]
  end

  test "push & pop" do
    state =
      VM.run([
        {:push, 5},
        {:pop},
        {:halt}
      ])

    assert state.stack == []
  end

  test "pop empty stack" do
    state =
      VM.run([
        {:pop},
        {:halt}
      ])

    assert state.stack == []
    assert state.valid == false
  end

  test "store" do
    state =
      VM.run([
        {:push, 123},
        {:store, 1, 0},
        {:halt}
      ])

    assert state.valid == true
    assert state.stack == []
    assert state.memory == %{{1, 0} => 123}
  end

  test "store & fetch" do
    state =
      VM.run([
        {:push, 123},
        {:store, 1, 0},
        {:fetch, 1, 0},
        {:halt}
      ])

    assert state.valid == true
    assert state.stack == [123]
  end
end
