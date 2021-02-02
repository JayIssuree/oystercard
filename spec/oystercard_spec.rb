require 'oystercard'

describe Oystercard do

    let(:entry_station) { double :station }
    let(:exit_station) { double :station }
    
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
            
            it 'changes in_journey? from false to true' do
                expect{ subject.touch_in(entry_station) }.to change{ subject.in_journey? }.from(false).to(true)
                expect(subject).to be_in_journey
            end

            it 'raises an error if there are insufficient funds upon touching in' do
                subject = described_class.new
                expect{ subject.touch_in(entry_station) }.to raise_error("Insufficient funds")
                expect(subject).to_not be_in_journey
            end
            
            it 'saves the entry station' do
                expect{ subject.touch_in(entry_station) }.to change{ subject.entry_station }.from(nil).to(entry_station)

            end

        end

        describe '#touch_out' do
            
            it 'changes in_journey? from true to false' do
                subject.touch_in(entry_station)
                expect{ subject.touch_out(exit_station) }.to change{ subject.in_journey? }.from(true).to(false)
                expect(subject).to_not be_in_journey
            end

            it 'charges the card the minimum fare for a journey' do
                subject.touch_in(entry_station)
                expect{ subject.touch_out(exit_station) }.to change{ subject.balance }.by(-Oystercard::MINIMUN_FARE)
            end

            it 'forgets the entry station on touch out' do
                subject.touch_in(entry_station)
                expect{ subject.touch_out(exit_station) }.to change{ subject.entry_station }.from(entry_station).to(nil)
            end

        end

        describe 'saving journey history' do
            
            it 'saves a complete journey' do
                subject.touch_in(entry_station)
                subject.touch_out(exit_station)
                expect(subject.journey_history).to include( { entry_station: entry_station, exit_station: exit_station } )
            end

        end

    end

    
end