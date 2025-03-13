defmodule DataIngestion.DataGeneration do
  @moduledoc """
  This module holds functions common to all data generation modules.
  """

  @type feedlot() ::
    %{
      timestamp: String.t(),
      lot_id: String.t(),
      location: %{lat: float(), lon: float()},
      cows: [cow()]
    }
  @type cow() ::
    %{
      id: String.t(),
      lot_id: String.t(),
      feed_consumed_kg: float(),
      feed_source: String.t(),
      current_vaccinations: [String.t()],
      weight: float(),
      timestamp: String.t(),
      location: %{lat: float(), lon: float()}
      }
  @type scan() ::
    %{
      timestamp: String.t(),
      location: location()
    }
  @type weight() ::
    %{
      weight: float()
    }
  @type location() ::
    %{
      lat: float(),
      lon: float()
    }

  defmacro __using__(_opts) do
    quote do
      @type feedlot() :: unquote(__MODULE__).feedlot()
      @type cow() :: unquote(__MODULE__).cow()
      @type scan() :: unquote(__MODULE__).scan()
      @type weight() :: unquote(__MODULE__).weight()
      @type location() :: unquote(__MODULE__).location()

      @spec gen_scan_info(map()) :: scan() # part of a cow() or a feedlot()
      defp gen_scan_info(loc) do
        loc =
          if loc == %{},
            do: gen_random_loc(),
          else: loc

        %{
          timestamp: DateTime.utc_now() |> DateTime.to_iso8601(),
          location: loc
        }
      end

      @spec gen_random_loc() :: location()
      defp gen_random_loc do
        %{
          lat: Float.round(:rand.uniform() * 180 - 90, 6),
          lon: Float.round(:rand.uniform() * 360 - 180, 6)
        }
      end
    end
  end
end
