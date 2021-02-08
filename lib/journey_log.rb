require_relative 'journey'

class JourneyLog

    attr_reader :journey_class

    def initialize(journey_class = Journey)
        @journey_class = journey_class
        @history = []
    end

    def history
        @history.dup
    end

    def start(station)
        complete_journey if in_journey?
        current_journey.save_entry_station(station)
    end

    def finish(station)
        current_journey.save_exit_station(station)
        complete_journey
    end

    def current_journey
        @current_journey ||= journey_class.new
    end

    private

    def save_journey
        @history << current_journey
    end

    def complete_journey
        save_journey
        @current_journey = nil
    end

    def in_journey?
        current_journey.in_progress?
    end

end