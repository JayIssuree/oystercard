require_relative 'station'
require_relative 'journey_log'

class Oystercard

    MAXIMUM_BALANCE = 90
    MINIMUN_FARE = 1

    attr_reader :balance, :journey_log

    def initialize(journey_log_class: JourneyLog)
        @journey_log = journey_log_class.new
        @balance = 0
    end

    def journey_history
        journey_log.history
    end

    def current_journey
        journey_log.current_journey
    end

    def in_journey?
        current_journey.in_progress?
    end

    def top_up(amount)
        top_up_limit_check(amount)
        @balance += amount
    end

    def touch_in(station)
        insufficient_funds_check
        deduct_penalty_fare if in_journey?
        journey_log.start(station)
    end

    def touch_out(station)
        journey_log.finish(station)
        deduct_completed_fare
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

    def deduct_penalty_fare
        deduct(current_journey.fare)
    end

    def deduct_completed_fare
        deduct(journey_history.last.fare)
    end

end