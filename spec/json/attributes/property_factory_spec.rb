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

  
  describe "build member variable" do
    it { 
      create(name: 'car', type: 'string').member_variable.should eq 'private String car = null;'
    }
    
    it { 
      create(name: 'address', type: 'address_wrapper').member_variable.should eq 'private AddressWrapper address = null;'
    }
  end


  describe "build getter" do
    it { 
      create(name: 'car', type: 'string').getter.should eq 'public final String getCar() { return null != this.car ? this.car : getCarDefault(); }'
    }

    it { 
      create(name: 'address', type: 'address_wrapper').getter.should eq 'public final AddressWrapper getAddress() { return null != this.address ? this.address : getAddressDefault(); }'
    }
  end


  describe "build setter" do
    it {
      create(name: 'car', type: 'string').setter.should eq 'public final String setCar(String _car) { return this.car = _car; }'
    }

    it {
      create(name: 'address', type: 'address_wrapper').setter.should  eq 'public final AddressWrapper setAddress(AddressWrapper _address) { return this.address = _address; }'
    }
  end


  describe "build default" do
    it { 
      create(name: 'car', type: 'string').default.should eq 'public final String getCarDefault() { return null; }'
    }

    it { 
      create(name: 'car', type: 'string', default: nil).default.should eq 'public final String getCarDefault() { return null; }'
    }

    it { 
      create(name: 'car', type: 'string', default: 'Subaru').default.should eq 'public final String getCarDefault() { return "Subaru"; }'
    }
  end  
end
