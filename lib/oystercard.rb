class Oystercard

    MAXIMUM_BALANCE = 90
    MINIMUN_FARE = 1

    attr_reader :balance, :entry_station, :exit_station, :journey_history

    def initialize
        @journey_history = []
        @entry_station = nil
        @exit_station = nil
        @balance = 0
    end

    def in_journey?
        !!entry_station
    end

    def top_up(amount)
        top_up_limit_check(amount)
        @balance += amount
    end

    def touch_in(station)
        insufficient_funds_check
        @entry_station = station
    end

    def touch_out(station)
        deduct(MINIMUN_FARE)
        @exit_station = station
        complete_journey
    end

    private

    def top_up_limit_check(amount)
        fail "Unable to top up above £#{MAXIMUM_BALANCE}" if @balance + amount > MAXIMUM_BALANCE
    end

    def insufficient_funds_check
        fail "Insufficient funds" if balance < MINIMUN_FARE
    end

    def deduct(amount)
        @balance -= amount
    end

    def complete_journey
        save_journey
        clear_journey
    end

    def save_journey
        journey_history << { entry_station: entry_station, exit_station: exit_station }
    end

    def clear_journey
        @entry_station = nil
        @exit_station = nil
    end

end