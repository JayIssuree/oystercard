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

    describe '#deduct(amount)' do

        it 'deducts the fare from the balance' do    
            subject.top_up(10)
            expect{ subject.deduct(3) }.to change{ subject.balance }.by(-3)
        end
    end

    context 'when on a journey' do
        
        describe '#touch_in' do
            
            it 'changes in_journey? from false to true' do
                expect{ subject.touch_in }.to change{ subject.in_journey? }.from(false).to(true)
                expect(subject).to be_in_journey
            end

        end

        describe '#touch_out' do
            
            it 'changes in_journey? from true to false' do
                subject.touch_in
                expect{ subject.touch_out }.to change{ subject.in_journey? }.from(true).to(false)
                expect(subject).to_not be_in_journey
            end

        end

    end

    
end