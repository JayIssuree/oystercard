require 'oystercard'

describe Oystercard do
    
    describe '#initialization' do
        
        it 'initializes with a default balance of 0' do
            expect(subject.balance).to eq(0)
        end

    end

    describe '#top_up(amount)' do
        
        it 'tops up the desired amount' do
            expect{ subject.top_up(10) }.to change{ subject.balance }.by(10)
        end

    end

    
end