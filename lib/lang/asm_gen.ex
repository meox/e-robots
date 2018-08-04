defmodule ASM.Generator do
  alias ASM.GenCTX

  def generate(vm_code) do
    # vm_code
    ctx = gen(vm_code, %GenCTX{})
    code = Enum.reverse(ctx.code)
    # |> Enum.flat_map(fn x -> x end)
    %{ctx | code: code}
  end

  ###  PRIVATE

  defp gen([], ctx = %GenCTX{}), do: ctx

  defp gen([op | ops], ctx = %GenCTX{}) do
    {ctx, c} = decode(op, ctx)
    gen(ops, %{ctx | code: [c | ctx.code], line: ctx.line + 1})
  end

  defp decode({:op, [{:keyword, "STORE"}, {:params, params} | _]}, ctx) do
    gen_store(params, ctx)
  end

  defp decode({:op, instruction}, ctx) do
    {ctx, instruction}
  end

  ### Gen

  defp gen_store([addr, val], ctx) do
    {
      ctx,
      [
        {:push, val},
        {:store, ctx.memory_region, addr}
      ]
    }
  end

  defp gen_store([addr], ctx) do
    {ctx, {:store, ctx.memory_region, addr}}
  end
end
