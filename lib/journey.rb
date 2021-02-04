class Journey

    attr_reader :entry_station, :exit_station

    PENALTY_FARE = 6
    MINIMUM_FARE = 1

    def save_entry_station(station)
        @entry_station = station
    end

    def save_exit_station(station)
        @exit_station = station
    end

    def in_progress?
        !!entry_station
    end

    def complete?
        !!(entry_station && exit_station)
    end

    def fare
        calculate_fare
    end

    private

    def calculate_fare
        complete? ? MINIMUM_FARE : PENALTY_FARE
    end

end