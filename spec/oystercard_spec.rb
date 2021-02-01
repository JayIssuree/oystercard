require 'oystercard'

describe Oystercard do
    
    describe '#initialization' do
        
        it 'initializes with a default balance of 0' do
            expect(subject.balance).to eq(0)
        end

    end

    
end