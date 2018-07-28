defmodule VM.State do
  defstruct(
    # instruction pointer
    ip: 0,

    # current stack
    stack: [],

    # valid
    valid: true,

    # describe the current state
    # usefull in case of error
    desc: ""
  )
end
