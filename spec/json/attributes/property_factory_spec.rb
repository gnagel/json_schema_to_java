require_relative '../../spec_helper.rb'

describe Json::Attributes::PropertyFactory do
  # Shorthand for creating the factory
  def create(opts = {})
    Json::Attributes::PropertyFactory.new(opts)
  end
  
  describe "PropertyFactory.new raises ArgumentError with insufficient inputs" do
    it { expect{ create() }.to raise_error ArgumentError}
    it { expect{ create(name: nil,     type: nil) }.to raise_error ArgumentError}
    it { expect{ create(name: nil,     type: 'pie' ) }.to raise_error ArgumentError}
    it { expect{ create(name: 'apple', type: nil   ) }.to raise_error ArgumentError}
    it { expect{ create(name: 'apple', type: 'pie' ) }.to_not raise_error ArgumentError}
  end
  
  
end
