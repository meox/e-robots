defmodule ASM.Generator do
  alias ASM.CTX

  def generate(vm_code) do
    # vm_code
    ctx = gen(vm_code, %CTX{})
    code = Enum.reverse(ctx.code)
    # |> Enum.flat_map(fn x -> x end)
    %{ctx | code: code}
  end

  ###  PRIVATE

  defp gen([], ctx = %CTX{}), do: ctx

  defp gen([op | ops], ctx = %CTX{}) do
    {:op, inst} = op
    {ctx, c} = manage_label(ctx, Keyword.get(inst, :label))
    |> decode(convert_instruction(op))

    gen(ops, %{ctx | code: [c | ctx.code], line: ctx.line + 1})
  end

  defp decode(ctx, %{:keyword => "STORE", :params => params}) do
    gen_store(params, ctx)
  end
  
  defp decode(ctx, %{:keyword => "FETCH", :params => [addr]}) do
    {ctx, {:fetch, ctx.memory_region, addr}}
  end

  defp decode(ctx, %{:keyword => "PUSH", :params => [e]}) do
    {ctx, {:push, e}}
  end

  defp decode(ctx, %{:keyword => "HALT"}), do: {ctx, {:halt}}

  defp decode(ctx, %{:keyword => "ADD"}), do: {ctx, {:add}}
  defp decode(ctx, %{:keyword => "MUL"}), do: {ctx, {:mul}}
  defp decode(ctx, %{:keyword => "DIV"}), do: {ctx, {:div}}


  defp decode(ctx, instruction) do
    {ctx, instruction}
  end

  ###

  defp convert_instruction({:op, inst}) do
    Enum.into(inst, %{})
  end

  defp manage_label(ctx, nil), do: ctx
  defp manage_label(ctx, label) do
    %{ctx | labels: Map.put_new(ctx.labels, label, ctx.line)}
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
