defmodule CDGenTest do
  alias DataIngestion.DataGeneration.CattleDataGenerator, as: CDGen
  use ExUnit.Case

  describe "gen_feedlot_data/1" do
    test "generates feedlot data with the specified number of cows" do
      num_cows = 5
      feedlot = CDGen.gen_feedlot_data(num_cows)

      # Check that the feedlot has a generated lot ID and a list of cows.
      assert is_binary(feedlot.lot_id)
      assert is_list(feedlot.cows)
      assert length(feedlot.cows) == num_cows

      # Verify that each cow has a unique id.
      cow_ids = Enum.map(feedlot.cows, & &1.id)
      assert length(Enum.uniq(cow_ids)) == num_cows

      # Ensure each cow's lot_id matches the feedlot's lot_id and numeric fields are in expected ranges.
      for cow <- feedlot.cows do
        assert cow.lot_id == feedlot.lot_id
        assert is_number(cow.weight) and cow.weight >= 400 and cow.weight <= 1100
        assert is_float(cow.feed_consumed_kg) and cow.feed_consumed_kg >= 0 and cow.feed_consumed_kg <= 30
      end
    end
  end

  describe "gen_cow_data/1" do
    test "generates cow data with provided lot info" do
      lot = %{lot_id: "lot_test", location: %{lat: 1.23, lon: 4.56}}
      cow = CDGen.gen_cow_data(lot)

      # Check that the cow's lot_id matches the provided one and all expected keys are present.
      assert is_binary(cow.id)
      assert cow.lot_id == "lot_test"
      assert is_number(cow.weight) and cow.weight >= 400 and cow.weight <= 1100
      assert is_float(cow.feed_consumed_kg) and cow.feed_consumed_kg >= 0 and cow.feed_consumed_kg <= 30
      assert cow.feed_source in ["feed_supplier_a", "feed_supplier_b"]
      assert is_list(cow.current_vaccinations)
    end

    test "generates cow data with a generated lot_id when an empty lot is provided" do
      cow = CDGen.gen_cow_data(%{})

      # When no lot info is given, a lot_id should be generated with a "lot_" prefix.
      assert cow.lot_id |> String.starts_with?("lot_")
      assert is_binary(cow.id)
      assert is_number(cow.weight) and cow.weight >= 400 and cow.weight <= 1100
      assert is_float(cow.feed_consumed_kg) and cow.feed_consumed_kg >= 0 and cow.feed_consumed_kg <= 30
      assert cow.feed_source in ["feed_supplier_a", "feed_supplier_b"]
      assert is_list(cow.current_vaccinations)
    end

    test "generates cow data correctly when no argument is passed" do
      # Using the default argument (empty map) by not passing any value.
      cow = CDGen.gen_cow_data()

      assert cow.lot_id |> String.starts_with?("lot_")
      assert is_binary(cow.id)
      assert is_number(cow.weight) and cow.weight >= 400 and cow.weight <= 1100
      assert is_float(cow.feed_consumed_kg) and cow.feed_consumed_kg >= 0 and cow.feed_consumed_kg <= 30
      assert cow.feed_source in ["feed_supplier_a", "feed_supplier_b"]
      assert is_list(cow.current_vaccinations)
    end
  end
end
