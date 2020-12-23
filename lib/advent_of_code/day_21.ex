import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day21 do
  @type recipe :: %{
          ingredients: [String.t()],
          allergens: [String.t()]
        }

  @spec parse_lines([String.t()]) :: [recipe]
  defp parse_lines(lines) do
    Enum.map(lines, fn line ->
      String.slice(line, 0, String.length(line) - 1)
      |> String.split(" (contains ")
      |> (fn [ingredients, allergens] ->
            %{
              ingredients: String.split(ingredients, " ") |> MapSet.new(),
              allergens: String.split(allergens, ", ")
            }
          end).()
    end)
  end

  @spec get_allergen_to_ingredient_mapping([recipe]) :: {%{}, %{}}
  defp get_allergen_to_ingredient_mapping(recipes) do
    Enum.reduce(
      recipes,
      {%{}, %{}},
      fn %{
           allergens: allergens,
           ingredients: ingredients
         },
         {allergen_to_ingredient, ingredients_counter} ->
        allergen_to_ingredient =
          Enum.reduce(allergens, allergen_to_ingredient, fn allergen, allergen_to_ingredient ->
            Map.update(
              allergen_to_ingredient,
              allergen,
              ingredients,
              &MapSet.intersection(&1, ingredients)
            )
          end)

        ingredients_counter =
          Enum.reduce(ingredients, ingredients_counter, fn ingredient, ingredients_counter ->
            Map.update(ingredients_counter, ingredient, 1, &(&1 + 1))
          end)

        {
          allergen_to_ingredient,
          ingredients_counter
        }
      end
    )
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    {allergen_to_ingredient, ingredients_counter} =
      read_lines(filename)
      |> parse_lines()
      |> get_allergen_to_ingredient_mapping()

    allergen_ingredients =
      Enum.flat_map(allergen_to_ingredient, fn {_, ingredients} -> ingredients end)
      |> MapSet.new()

    Enum.filter(ingredients_counter, fn {ingredient, _} ->
      not MapSet.member?(allergen_ingredients, ingredient)
    end)
    |> Enum.map(fn {_, count} -> count end)
    |> Enum.sum()
  end

  @spec part2(String.t()) :: String.t()
  def part2(filename) do
    {allergen_to_ingredients, _} =
      read_lines(filename)
      |> parse_lines()
      |> get_allergen_to_ingredient_mapping()

    {_, allergen_result} =
      Enum.reduce(
        1..map_size(allergen_to_ingredients),
        {allergen_to_ingredients, %{}},
        fn _, {allergen_to_ingredients, allergen_result} ->
          {allergen, ingredients} =
            Enum.find(allergen_to_ingredients, fn {_, ingredients} ->
              MapSet.size(ingredients) == 1
            end)

          ingredient = MapSet.to_list(ingredients) |> Enum.at(0)
          allergen_result = Map.put(allergen_result, allergen, ingredient)

          allergen_to_ingredients =
            Enum.map(allergen_to_ingredients, fn {allergen, ingredients} ->
              {allergen, Enum.filter(ingredients, &(&1 != ingredient)) |> MapSet.new()}
            end)

          {allergen_to_ingredients, allergen_result}
        end
      )

    Enum.sort_by(allergen_result, fn {allergen, _} -> allergen end, &<=/2)
    |> Enum.map(fn {_, ingredient} -> ingredient end)
    |> Enum.join(",")
  end
end
