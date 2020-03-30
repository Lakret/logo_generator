defmodule LogoGenerator do
  @moduledoc """
  Modern Retro Tech logo generator.
  """

  @type component :: 0..255
  @type image :: [[{red :: component, green :: component, blue :: component}]]

  @doc """
  Generates Modern Retro Tech logo image.

  Usage:

  ```elixir
  import LogoGenerator

  logo = logo()
  write_ppm! "logo.ppm", logo
  ```

  The generated PPM file can be opened and converted to PNG via `open logo.ppm`.
  """
  @spec logo() :: image
  def logo() do
    {width, height} = {500, 500}

    background =
      for y <- 1..height do
        for x <- 1..width do
          r = round(255 * (x / 350))
          g = round(255 - 255 * (y / 500))
          b = 255

          {r, g, b}
        end
      end

    background
  end

  @doc """
  Returns a test image.

  Should look like two rows, each with 3 different colors:

  ```
  red green blue
  yellow white black
  ```
  """
  @spec test_image() :: image
  def test_image() do
    [
      [{255, 0, 0}, {0, 255, 0}, {0, 0, 255}],
      [{255, 255, 0}, {255, 255, 255}, {0, 0, 0}]
    ]
  end

  @doc """
  Writes `image` as a PPM file at `path`.
  """
  @spec write_ppm!(Path.t(), image()) :: :ok
  def write_ppm!(path, image) do
    {width, height} = {width(image), height(image)}

    body =
      Enum.map(image, fn row ->
        Enum.map(row, fn {r, g, b} -> "#{r} #{g} #{b}" end)
        |> Enum.join("\t")
      end)
      |> Enum.join("\n")

    content = """
    P3
    #{width} #{height}
    255
    #{body}
    """

    File.write!(path, content)
  end

  @spec width(image) :: non_neg_integer()
  def width([first_row | _] = _image), do: length(first_row)

  @spec height(image) :: non_neg_integer()
  def height(image), do: length(image)
end
