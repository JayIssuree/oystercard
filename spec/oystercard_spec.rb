require 'oystercard'

describe Oystercard do
    
    describe '#initialization' do
        
        it 'initializes with a default balance of 0' do
            expect(subject.balance).to eq(0)
        end

        it 'initializes not being in_journey' do
            expect(subject).to_not be_in_journey
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
                expect{ subject.touch_in }.to change{ subject.in_journey? }.from(false).to(true)
                expect(subject).to be_in_journey
            end

            it 'raises an error if there are insufficient funds upon touching in' do
                subject = described_class.new
                expect{ subject.touch_in }.to raise_error("Insufficient funds")
                expect(subject).to_not be_in_journey
            end

        end

        describe '#touch_out' do
            
            it 'changes in_journey? from true to false' do
                subject.touch_in
                expect{ subject.touch_out }.to change{ subject.in_journey? }.from(true).to(false)
                expect(subject).to_not be_in_journey
            end

            it 'charges the card the minimum fare for a journey' do
                subject.touch_in
                expect{ subject.touch_out }.to change{ subject.balance }.by(-Oystercard::MINIMUN_FARE)
            end

        end

    end

    
end