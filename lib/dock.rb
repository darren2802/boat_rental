class Dock

  attr_reader :name, :max_rental_time, :rental_log, :revenue

  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @rental_log = Hash.new
    @revenue = 0
  end

  def rent(boat, renter)
    @rental_log[boat] = renter
  end

  def charge(boat)
    renter = @rental_log[boat]
    total_charge = [boat.hours_rented * boat.price_per_hour, max_rental_time * boat.price_per_hour].min
    charge = {
      :card_number => renter.credit_card_number,
      :amount => total_charge
    }
  end

  def log_hour
    @rental_log.each_key { |key| key.add_hour }
  end

  def return(boat)
    @revenue += charge(boat)[:amount]
    @rental_log.delete(boat)
  end

end
