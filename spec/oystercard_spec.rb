require 'oystercard'

describe Oystercard do

    let(:entry_station) { double :station }
    let(:exit_station) { double :station }
    let(:journey_log_class) { double :journey_log_class, :new => journey_log }
    let(:journey_log) { double :journey_log, :current_journey => journey, :history => [], :start => nil, :finish => nil }
    let(:journey) { double :journey, :fare => 0 }

    let(:subject) { described_class.new(journey_log_class: journey_log_class) }
    
    describe '#initialization' do
        
        it 'initializes with a default balance of 0' do
            expect(subject.balance).to eq(0)
        end

        it 'calls journey.in_progress' do
            expect(journey).to receive(:in_progress?)
            subject.in_journey?
        end

        it 'initializes with an empty list of journeys' do
            expect(journey_log).to receive(:history)
            expect(subject.journey_history).to be_empty
        end

        it 'initializes with a journey log' do
            expect(subject.journey_log).to eq(journey_log)
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
            allow(journey).to receive(:in_progress?).and_return(false)
        }
        
        describe '#touch_in' do
            
            it 'calls journey_log.start on touching in' do
                expect(journey_log).to receive(:start).with(entry_station)
                subject.touch_in(entry_station)
            end

            it 'raises an error if there are insufficient funds upon touching in' do
                subject = described_class.new(journey_log_class: journey_log_class)
                expect{ subject.touch_in(entry_station) }.to raise_error("Insufficient funds")
                expect(subject).to_not be_in_journey
            end

            it 'calls deduct(fare) when touching in while already on an incomplete journey' do
                allow(journey).to receive(:in_progress?).and_return(true)
                expect(subject).to receive(:deduct).with(journey.fare)
                subject.touch_in(entry_station)
            end

        end

        describe '#touch_out' do
            
            it 'calls jourey_log.finish on touching out' do
                subject.touch_in(entry_station)
                allow(journey).to receive(:in_progress?).and_return(true)
                allow(journey_log).to receive(:history).and_return([journey])
                expect(journey_log).to receive(:finish).with(exit_station)
                subject.touch_out(exit_station)
            end

            it 'calls deduct(journey.fare) when touching out' do
                subject.touch_in(entry_station)
                allow(journey).to receive(:in_progress?).and_return(true)
                allow(journey_log).to receive(:history).and_return([journey])
                expect(journey).to receive(:fare)
                expect(subject).to receive(:deduct).with(journey.fare)
                subject.touch_out(exit_station)
            end

        end

    end

    
end