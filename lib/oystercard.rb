class Oystercard

    MAXIMUM_BALANCE = 90
    MINIMUN_FARE = 1

    attr_reader :balance, :entry_station

    def initialize
        @entry_station = nil
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
        @in_journey = true
    end

    def touch_out
        deduct(MINIMUN_FARE)
        @entry_station = nil
        @in_journey = false
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

end