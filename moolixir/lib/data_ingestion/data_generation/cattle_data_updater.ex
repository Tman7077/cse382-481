defmodule DataIngestion.DataGeneration.CattleDataUpdater do
  @moduledoc """
  This module is responsible for updating cattle data.
  The goal is to take in data from either a single cow
    or an entire feedlot and update the data structure
    with the latest information.
  This is to simulate the ingestion of data
    about cattle or feedlots for which is already present,
    updating to the latest information to maintain currency.
  """

  use DataIngestion.DataGeneration

  @doc """
  Updates an existing feedlot data structure
    with new cattle scan information.
  """
  @spec update_feedlot_data(feedlot()) :: feedlot()
  def update_feedlot_data(lot) do
    lot
    |> Map.update!(:cows, fn cows ->
      Enum.map(cows, fn cow ->
        cow
        |> update_cow_data()
      end)
    end)
    |> update(gen_scan_info(lot.location))
  end

  @doc """
  Updates a cow data structure, combining
  ingestion from a **scale** (```weigh_cow```)
  and a **tag scanner** (```rescan_cow```).
  """
  @spec update_cow_data(cow()) :: cow()
  def update_cow_data(cow) do
    diff = Float.round(:rand.uniform() * 2 - 1, 3)
    cow
    |> rescan(diff)
    |> reweigh(diff)
    |> update(gen_scan_info(cow.location))
  end

  @spec rescan(cow(), float()) :: cow()
  defp rescan(cow, diff) do
    cow
    |> update(
      %{
        feed_consumed_kg: cow.feed_consumed_kg + (diff * 3),  # Feed between -3kg and +3kg
        current_vaccinations: Enum.take(["Rabies", "BVD", "IBR", "Brucellosis"], :rand.uniform(4))
      })
  end

  @spec reweigh(cow(), float()) :: cow()
  defp reweigh(cow, diff) do
    Map.update!(cow, :weight, fn weight ->
      weight + (diff * 10) # Weight between -30kg and +30kg
    end)
  end

  @spec update(map(), map()) :: map()
  defp update(old, new) do
    Map.merge(old, new,
      fn _, _, new -> new end
    )
  end
end
