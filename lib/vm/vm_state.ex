defmodule VM.State do
  defstruct(
    # instruction pointer
    ip: 0,

    # current stack
    stack: [],

    # message list
    msgs: [],

    # valid
    valid: true,

    # memory
    # {region, addr} -> value
    # the key is a region + address
    # region = 0, means global memory
    memory: %{},

    # describe the current state
    # usefull in case of error
    desc: ""
  )
end
