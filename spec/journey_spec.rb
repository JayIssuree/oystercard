require 'journey'

describe Journey do

    let(:entry_station) { double :station }
    let(:exit_station) { double :station }

    describe '#initialization' do

        it 'initializes with no stations saved' do
            expect(subject.entry_station).to be_nil
            expect(subject.exit_station).to be_nil
        end

        it 'intializes not being in progress' do
            expect(subject).to_not be_in_progress
        end

        it 'initialized as incomplete' do
            expect(subject).to_not be_complete
        end

    end
    
    describe '#save_entry_station(station)' do

        it 'saves the entry station' do
            expect{ subject.save_entry_station(entry_station) }.to change{ subject.entry_station }.from(nil).to(entry_station)
        end

    end

    describe '#save_exit_station' do

        it 'saves the exit station' do
            expect{ subject.save_exit_station(exit_station) }.to change{ subject.exit_station }.from(nil).to(exit_station)
        end
        
    end

    describe '#in_progress' do
        
        it 'is in progress when there is an entry station' do
            subject.save_entry_station(entry_station)
            expect(subject).to be_in_progress
        end

        it 'is not progress when there is only an exit station' do
            subject.save_exit_station(exit_station)
            expect(subject).to_not be_in_progress
        end

    end

    describe '#complete' do
        
        it 'is not complete when there is only an entry station' do
            subject.save_entry_station(entry_station)
            expect(subject).to_not be_complete
        end

        it 'is not complete when there is only an exit station' do
            subject.save_exit_station(exit_station)
            expect(subject).to_not be_complete
        end

        it 'is complete when there are both entry and exit stations' do
            subject.save_entry_station(entry_station)
            subject.save_exit_station(exit_station)
            expect(subject).to be_complete
        end

    end

end