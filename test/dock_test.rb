require 'minitest/autorun'
require_relative '../lib/dock'
require_relative '../lib/renter'
require_relative '../lib/boat'

class TestDock < Minitest::Test

  def setup
    @dock = Dock.new("The Rowing Dock", 3)
    @kayak_1 = Boat.new(:kayak, 20)
    @kayak_2 = Boat.new(:kayak, 20)
    @canoe = Boat.new(:canoe, 25)
    @sup_1 = Boat.new(:standup_paddle_board, 15)
    @sup_2 = Boat.new(:standup_paddle_board, 15)
    @patrick = Renter.new("Patrick Star", "4242424242424242")
    @eugene = Renter.new("Eugene Crabs", "1313131313131313")
  end

  def test_dock_initialized
    assert_instance_of Dock, @dock
    assert_equal "The Rowing Dock", @dock.name
    assert_equal 3, @dock.max_rental_time
  end

  def test_dock_rent_some_boats
    rental_log = {
      @kayak_1 => @patrick,
      @kayak_2 => @patrick,
      @sup_1 => @eugene
    }
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)
    assert_equal rental_log, @dock.rental_log
  end

  def test_dock_charge_kayak
    charge_result = { :card_number => "4242424242424242", :amount => 40 }
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @kayak_1.add_hour
    @kayak_1.add_hour
    assert_equal charge_result, @dock.charge(@kayak_1)
  end

  def test_dock_charge_sup_1
    charge_result = { :card_number => "1313131313131313", :amount => 45 }
    @dock.rent(@sup_1, @eugene)
    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    assert_equal charge_result, @dock.charge(@sup_1)
  end

  def test_dock_log_hours
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour
    assert_equal [1, 1], [@kayak_1.hours_rented, @kayak_2.hours_rented]
    @dock.rent(@canoe, @patrick)
    @dock.log_hour
    assert_equal [2, 2, 1], [@kayak_1.hours_rented, @kayak_2.hours_rented, @canoe.hours_rented]
  end

  def test_dock_return_boats_calculate_revenue
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour
    @dock.rent(@canoe, @patrick)
    @dock.log_hour
    assert_equal 0, @dock.revenue
    @dock.return(@kayak_1)
    @dock.return(@kayak_2)
    @dock.return(@canoe)
    assert_equal 105, @dock.revenue
    @dock.rent(@sup_1, @eugene)
    @dock.rent(@sup_2, @eugene)
    5.times { @dock.log_hour }
    @dock.return(@sup_1)
    @dock.return(@sup_2)
    assert_equal 195, @dock.revenue
  end

end
