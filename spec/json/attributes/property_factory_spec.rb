require_relative '../../spec_helper.rb'

describe Json::Attributes::PropertyFactory do
  # Shorthand for creating the factory
  def create(opts = {})
    Json::Attributes::PropertyFactory.new(opts)
  end
  
  describe "new raises ArgumentError with insufficient inputs" do
    it { expect{ create() }.to raise_error ArgumentError}
    it { expect{ create(name: nil,     type: nil) }.to raise_error ArgumentError}
    it { expect{ create(name: nil,     type: 'pie' ) }.to raise_error ArgumentError}
    it { expect{ create(name: 'apple', type: nil   ) }.to raise_error ArgumentError}
    it { expect{ create(name: 'apple', type: 'pie' ) }.to_not raise_error ArgumentError}
  end
  
  
  describe "builds getter, setter, and defaults" do
    before(:each) { @factory = create(name: 'car', type: 'string', required: false, default: 'Subaru') }
    
    it { @factory.default.should match /public final String getCarDefault() { return "Subaru"; }/ }
    it { @factory.getter.should  match /public final String getCar() { return null != this.car ? this.car : getCarDefault(); }/ }
    it { @factory.setter.should  match /public final String setCar(String _car) { return this.car = _car; }/ }
  end
  
end
