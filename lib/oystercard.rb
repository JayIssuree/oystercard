class Oystercard

    MAXIMUM_BALANCE = 90
    MINIMUN_FARE = 1

    attr_reader :balance

    def initialize
        @in_journey = false
        @balance = 0
    end

    def in_journey?
        @in_journey
    end

    def top_up(amount)
        top_up_limit_check(amount)
        @balance += amount
    end

    def touch_in
        insufficient_funds_check
        @in_journey = true
    end

    def touch_out
        deduct(MINIMUN_FARE)
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