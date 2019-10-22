require 'minitest/autorun'
require_relative '../lib/boat'


class TestBoat < Minitest::Test

  def setup
    @kayak = Boat.new(:kayak, 20)
  end

  def test_boat_initialized
    assert_instance_of Boat, @kayak
    assert_equal :kayak, @kayak.type
    assert_equal 20, @kayak.price_per_hour
  end

  def test_boat_rent
    assert_equal 0, @kayak.hours_rented
    @kayak.add_hour
    @kayak.add_hour
    @kayak.add_hour
    assert_equal 3, @kayak.hours_rented
  end

end
