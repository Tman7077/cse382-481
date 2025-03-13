defmodule DataIngestion.DataGeneration.CattleDataGenerator do
  @moduledoc """
  This module is responsible for generating cattle data.
  The goal is to simulate the creation of data about cattle,
    as if it were being ingested from a real-world source
    such as a cattle scale and a tag scanner.
  It can also generate info from an entire feedlot
    (given a number of cows),
    ensuring each cow shares a lot ID and location.
  """

  use DataIngestion.DataGeneration

  @doc """
  Generates a feedlot data structure with a given number of cows.
  Each cow will have a unique ID, but share the same lot ID and location.
  """
  @spec gen_feedlot_data(non_neg_integer()) :: feedlot()
  def gen_feedlot_data(num_cows) do
    lot =
      gen_scan_info(gen_random_loc())
      |> Map.merge(%{
          lot_id: "lot_#{:crypto.strong_rand_bytes(5) |> Base.encode16}"
        })

    cows = Enum.map(1..num_cows, fn _ -> gen_cow_data(lot) end)

    Map.merge(lot, %{cows: cows})
  end

  @doc """
  Generates a cow data structure, combining
    ingestion from a **scale** (```weigh_cow```)
    and a **tag scanner** (```scan_cow```).
  """
  @spec gen_cow_data(map()) :: cow()
  def gen_cow_data(lot \\ %{}) do
    lot_id = Map.get(lot, :lot_id, "")
    loc = Map.get(lot, :location, %{})
    scan_cow(lot_id)
    |> Map.merge(weigh_cow())
    |> Map.merge(gen_scan_info(loc))
  end

  @spec scan_cow(String.t()) :: scan()
  defp scan_cow(lot_id) do
    lot_id =
      if lot_id == "",
        do: "lot_#{:crypto.strong_rand_bytes(5) |> Base.encode16}",
      else: lot_id

    %{
      id: "cow_#{:crypto.strong_rand_bytes(8) |> Base.encode16}",
      lot_id: lot_id,
      feed_consumed_kg: Float.round(:rand.uniform() * 30, 3),
      feed_source: Enum.random(["feed_supplier_a", "feed_supplier_b"]),
      current_vaccinations: Enum.take(["Rabies", "BVD", "IBR", "Brucellosis"], :rand.uniform(4))
    }
  end

  @spec weigh_cow() :: weight() # part of a cow()
  defp weigh_cow do
    %{
      weight: 400 + Float.round(:rand.uniform() * 700, 2)
    }
  end
end
