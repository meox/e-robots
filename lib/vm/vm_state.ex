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

    # describe the current state
    # usefull in case of error
    desc: ""
  )
end
