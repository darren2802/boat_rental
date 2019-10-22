require 'minitest/autorun'
require_relative '../lib/renter'

class TestRenter < Minitest::Test

  def setup
    @renter = Renter.new("Patrick Star", "4242424242424242")
  end

  def test_renter_initialized
    assert_instance_of Renter, @renter
    assert_equal "Patrick Star", @renter.name
    assert_equal "4242424242424242", @renter.credit_card_number
  end

end
