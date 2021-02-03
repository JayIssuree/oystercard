class Journey

    attr_reader :entry_station, :exit_station

    def initialize
        @entry_station = nil
        @exit_station = nil
    end

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

end