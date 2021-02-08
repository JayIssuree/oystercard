require 'journey_log'

describe JourneyLog do

    let(:station) { double :station }
    let(:journey_class) { double :journey_class, :new => journey }
    let(:journey) { double :journey, :save_entry_station => nil, :save_exit_station => nil, :in_progress? => nil }

    let(:subject) { described_class.new(journey_class) }
    
    describe '#initialization' do

        it 'is initialized with the journey class' do
            expect(subject.journey_class).to eq(journey_class)
        end

        it 'is initialized with an empty array' do
            expect(subject.history).to be_empty
        end

    end

    describe '#start(entry_station)' do
        
        it 'creates a new instance of journey' do
            expect(journey_class).to receive(:new)
            subject.start(station)
        end

        it 'saves the station to the journey' do
            expect(journey).to receive(:save_entry_station).with(station)
            subject.start(station)
        end

    end

    describe '#finish(exit_station)' do

        it 'saves the station to the journey' do
            expect(journey).to receive(:save_exit_station).with(station)
            subject.finish(station)
        end

    end

    context 'completed journey' do
        
        it 'saves the completed journey' do
            subject.start(station)
            allow(journey).to receive(:in_progress?).and_return(true)
            expect{ subject.finish(station) }.to change{ subject.history.length }.by(1)
        end

    end

end