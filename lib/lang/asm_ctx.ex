defmodule ASM.CTX do
  defstruct(
    code: [],
    labels: %{},
    line: 0,
    memory_region: 0,
    vars: %{},
    index_var: 0,
    error: false
  )
end
