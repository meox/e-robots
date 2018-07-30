defmodule ASM do
  @doc """
  From Assembler code generate a runnable code for the VM
  """

  alias ASM.Parser

  def compile(file_name) do
    case File.read(file_name) do
      {:ok, content} ->
        content
        |> parse()
        |> generate()

      {:error, msg} ->
        IO.puts("error: #{msg}")
    end
  end

  defp parse(content) do
    Parser.program(content)
  end

  defp generate(ast) do
    ast
  end
end
