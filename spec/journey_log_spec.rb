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

        it 'saves the journey' do
            subject.start(station)
            allow(journey).to receive(:in_progress?).and_return(true)
            subject.start(station)
            expect(subject.journeys).to include(journey)
        end

    end

    describe '#finish(exit_station)' do
        
        it 'creates a new instance of journey if the current one is complete' do
            expect(journey_class).to receive(:new)
            subject.finish(station)
        end

        it 'saves the station to the journey' do
            expect(journey).to receive(:save_exit_station).with(station)
            subject.finish(station)
        end

        it 'saves the incomplete journey' do
            subject.finish(station)
            expect(subject.journeys).to include(journey)
        end

    end

    describe 'edge cases' do
        
        it 'saves only 1 journey' do
            subject.start(station)
            allow(journey).to receive(:in_progress?).and_return(true)
            subject.finish(station)
            expect(subject.journeys.length).to eq(1)
        end

    end

end