defmodule ASM.Parser do

  import NimbleParsec

  space = ascii_char([?\s, ?\t])
  spaces = repeat(space)
  spaces1 = times(space, min: 1)

  symbol =
    ascii_string([?a..?z, ?_], min: 1)
    |> repeat(
      ascii_char([?a..?z, ?_, ?0..?9])
      |> wrap()
      |> map({:to_string, []})
    )
    |> reduce({Enum, :join, [""]})

  bool_t =
    choice([
      string("true") |> replace(true),
      string("false") |> replace(false)
    ])

  int_t = integer(min: 1)

  float_t =
    times(ascii_char([?0..?9]), min: 1)
    |> concat(ascii_char([?.]))
    |> concat(times(ascii_char([?0..?9]), min: 1))
    |> reduce({List, :to_string, []})
    |> map({:compose_float, []})

  string_t =
    ignore(ascii_char([?"]))
    |> repeat_while(
      choice([
        ~S(\") |> string() |> replace(?"),
        utf8_char([])
      ]),
      {:not_quote, []}
    )
    |> ignore(ascii_char([?"]))
    |> reduce({List, :to_string, []})

  basic_type = choice([float_t, int_t, bool_t, string_t])

  defparsec :p_param,
    choice([
      symbol,
      basic_type
    ])

  # parameters list
  defparsec :p_params,
    parsec(:p_param)
    |> optional(
      repeat(
        ignore(spaces)
        |> ignore(ascii_char([?,]))
        |> ignore(spaces)
        |> concat(parsec(:p_param))
      )
    )
    |> tag(:params)


  defparsec :p_keyword,
    choice([
      string("STORE"),
      string("FETCH"),
      string("PUSH"),
      string("POP"),
      string("JUMP"),
      string("JLE"),
      string("JLT"),
      string("JGT"),
      string("JGE"),
      string("CALL"),
      string("ADD"),
      string("MUL"),
      string("DIV"),
      string("REM"),
      string("SIN"),
      string("COS"),
      string("TAN"),
      string("HALT")
    ])
    |> unwrap_and_tag(:keyword)


  defparsec :p_label,
    symbol
    |> ignore(ascii_char([?:]))
    |> unwrap_and_tag(:label)


  defparsec :p_comment,
    ignore(ascii_char([?#]))
    |> ignore(repeat_while(
      utf8_char([]),
      {:not_endline, []}
    ))

  defparsec :p_inst,
    optional(parsec(:p_label))
    |> optional(ignore(ascii_char([?\n])))
    |> ignore(spaces)
    |> concat(parsec(:p_keyword))
    |> ignore(spaces)
    |> concat(optional(parsec(:p_params)))
    |> ignore(spaces)
    |> optional(parsec(:p_comment))
    |> tag(:instruction)

  defparsec :program,
    repeat(
      choice([
        parsec(:p_comment),
        parsec(:p_inst),
      ])
      |> ignore(repeat(ascii_char([?\n])))
    )

  ### PRIVATE

  defp not_quote(<<?", _::binary>>, context, _, _), do: {:halt, context}
  defp not_quote(_, context, _, _), do: {:cont, context}

  defp not_endline(<<?\n, _::binary>>, context, _, _), do: {:halt, context}
  defp not_endline(_, context, _, _), do: {:cont, context}
  
  defp compose_float(s) do
    {x, ""} = Float.parse(s)
    x
  end

end