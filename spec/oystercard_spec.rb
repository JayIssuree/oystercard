require 'oystercard'

describe Oystercard do

    let(:entry_station) { double :station }
    let(:exit_station) { double :station }
    let(:journey_class) { double :journey_class, :new => journey }
    let(:journey) { double :journey, :save_entry_station => nil, :save_exit_station => nil }
    let(:subject) { described_class.new(journey_class) }
    
    describe '#initialization' do
        
        it 'initializes with a default balance of 0' do
            expect(subject.balance).to eq(0)
        end

        it 'initializes not being in_journey' do
            expect(subject).to_not be_in_journey
        end

        it 'initializes with an empty list of journeys' do
            expect(subject.journey_history).to be_empty
        end

        it 'initializes with a journey class' do
            expect(subject.journey).to eq(journey_class)
        end

        it 'does not call in_progress on the current journey when there is not a current journey' do
            expect(journey).not_to receive(:in_progress?)
            expect(subject.in_journey?).to be(false)
        end

    end

    describe '#top_up(amount)' do
        
        it 'tops up the desired amount' do
            expect{ subject.top_up(10) }.to change{ subject.balance }.by(10)
        end

        it 'raises an error when topping up above the balance limit' do
            maximum_balance = Oystercard::MAXIMUM_BALANCE
            expect{ subject.top_up(maximum_balance + 1) }.to raise_error("Unable to top up above £#{maximum_balance}")
        end

    end

    context 'when on a journey' do

        before(:each) {
            subject.top_up(Oystercard::MAXIMUM_BALANCE)
        }
        
        describe '#touch_in' do
            
            it 'calls journey.new on touching in' do
                expect(journey_class).to receive(:new)
                subject.touch_in(entry_station)
            end
            
            it 'calls journey.in_progress when having touched in' do
                subject.touch_in(entry_station)
                expect(journey).to receive(:in_progress?)
                subject.in_journey?
            end

            it 'raises an error if there are insufficient funds upon touching in' do
                subject = described_class.new(journey_class)
                expect{ subject.touch_in(entry_station) }.to raise_error("Insufficient funds")
                expect(subject).to_not be_in_journey
            end
            
            it 'calls journey.save)entry_station on touch in' do
                expect(journey).to receive(:save_entry_station).with(entry_station)
                subject.touch_in(entry_station)
            end

        end

        describe '#touch_out' do
            
            it 'calls journey.in_progress when having touched out' do
                subject.touch_in(entry_station)
                subject.touch_out(exit_station)
                expect(journey).to receive(:in_progress?)
                subject.in_journey?
            end

            it 'does not call in_progress on the current journey when there is not a current journey' do
                expect(journey).not_to receive(:in_progress?)
                expect(subject.in_journey?).to be(false)
            end

            it 'charges the card the minimum fare for a journey' do
                subject.touch_in(entry_station)
                expect{ subject.touch_out(exit_station) }.to change{ subject.balance }.by(-Oystercard::MINIMUN_FARE)
            end

            it 'calls jourey.save_exit_station on touch out' do
                subject.touch_in(entry_station)
                expect(journey).to receive(:save_exit_station).with(exit_station)
                subject.touch_out(exit_station)
            end

        end

        describe 'saving journey history' do
            
            it 'saves a complete journey' do
                subject.touch_in(entry_station)
                subject.touch_out(exit_station)
                expect(subject.journey_history).to include( journey )
            end

        end

    end

    
end