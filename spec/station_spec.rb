require 'station'

describe Station do

    let(:subject) { described_class.new(name: "RSPEC Station", zone: 5) }
    
    describe '#initialization' do
        
        it 'is initialized with a name' do
            expect(subject.name).to eq("RSPEC Station")
        end
        
        it 'is initialized with a zone' do
            expect(subject.zone).to eq(5)
        end
    end

end