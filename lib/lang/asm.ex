defmodule ASM do
  @doc """
  ByteCode generator

  const

  math: [add, sub, mul, div, rem, sin, cos, tan]

  # stack

  push
  pop
  ret
  dup

  # jump

  je
  jlt
  jlte
  jgt
  jgte

  """

  def compile(file_name) do
    case File.read(file_name) do
      {:ok, content} ->
        content
        |> parse()
        |> generate()

      {:error, msg} ->
        nil
    end
  end

  defp parse(content) do
  end

  defp generate(ast) do
    <<0>>
  end
end
