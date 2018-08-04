defmodule ASM do
  @doc """
  From Assembler code generate a runnable code for the VM
  """

  alias ASM.{Parser, Generator}

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

  ### PRIVATE

  defp parse(content) do
    Parser.program(content)
  end

  defp generate({:ok, vm_code, _, _, _, _}) do
    Generator.generate(vm_code)
  end

  defp generate(ast) do
    IO.puts("Error compiling assembler")
    IO.inspect(ast)
  end
end
