class Oystercard

    MAXIMUM_BALANCE = 90

    attr_reader :balance

    def initialize
        @balance = 0
    end

    def top_up(amount)
        top_up_limit_check(amount)
        @balance += amount
    end

    def deduct(amount)
        @balance -= amount
    end

    private

    def top_up_limit_check(amount)
        fail "Unable to top up above £#{MAXIMUM_BALANCE}" if @balance + amount > MAXIMUM_BALANCE
    end

end