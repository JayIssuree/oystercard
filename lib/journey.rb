class Journey

    attr_reader :entry_station, :exit_station

    PENALTY_FARE = 6
    MINIMUM_FARE = 1
    CHARGE_PER_ZONE = 1

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
        complete? ? zone_fare : PENALTY_FARE
    end

    def zone_fare
        MINIMUM_FARE + ((entry_station.zone - exit_station.zone).abs * CHARGE_PER_ZONE)
    end

end