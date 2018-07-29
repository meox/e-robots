defmodule ASM do
  @doc """
  From Assembler code generate a runnable code for the VM
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
