defmodule ASM.GenCTX do
  defstruct(
    code: [],
    labels: %{},
    line: 0,
    memory_region: 0,
    error: false
  )
end
