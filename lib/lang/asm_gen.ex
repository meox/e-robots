defmodule ASM.Generator do
  alias ASM.GenCTX

  def generate(vm_code) do
    #gen(vm_code, %GenCTX{})
  end

  defp gen([op, ops], ctx = %GenCTX{}) do
    #c = decode(op, ctx)
    #gen(ops, %{ctx | code: Map.put(ctx.code, c)})
  end

  ###

  #defp decode({:op}) do
  #end
end
