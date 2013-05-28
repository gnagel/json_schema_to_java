require_relative '../../spec_helper.rb'

describe Json::Attributes::PropertyFactory do
  # Shorthand for creating the factorys
  def create(opts = {})
    Json::Attributes::PropertyFactory.new(opts)
  end
  
  let(:car) do
    {
      name: 'car', 
      type: 'string'
    }
  end
  let(:car_is_required) { car.merge(required: true) }
  let(:car_with_default) { car.merge(default: 'Subaru') }
  let(:car_is_required_with_default) { car.merge(required: true, default: 'Subaru') }

  let(:address) do
    {
      name: 'address', 
      type: 'address_wrapper'
    }
  end
  let(:address_is_required) { address.merge(required: true) }
  let(:address_with_default) { address.merge(default: 'AddressWrapper.defaultValue()') }
  let(:address_is_required_with_default) { address.merge(required: true, default: 'AddressWrapper.defaultValue()') }
  
  def member_variable(opts = {})
    create(opts).member_variable
  end
  
  def getter(opts = {})
    create(opts).getter
  end
  
  def setter(opts = {})
    create(opts).setter
  end
  
  def default(opts = {})
    create(opts).default
  end
  
  describe "new raises ArgumentError with insufficient inputs" do
    it { expect{ create() }.to raise_error ArgumentError}
    it { expect{ create(name: nil,     type: nil) }.to raise_error ArgumentError}
    it { expect{ create(name: nil,     type: 'pie' ) }.to raise_error ArgumentError}
    it { expect{ create(name: 'apple', type: nil   ) }.to raise_error ArgumentError}
    it { expect{ create(name: 'apple', type: 'pie' ) }.to_not raise_error ArgumentError}
  end

  
  describe "member_variable" do
    let(:loose_value) { "@DatabaseField private #{value_postfix} = null;"}
    let(:strict_value) { "@DatabaseField(canBeNull = false, index = true) private #{value_postfix} = null;"}

    describe "simple string value" do
      let(:value_postfix) { 'String car' }

      it { member_variable(car).should === loose_value }
      it { member_variable(car_with_default).should === loose_value }

      it { member_variable(car_is_required).should === strict_value }
      it { member_variable(car_is_required_with_default).should === strict_value }
    end

    describe "generic class value" do
      let(:value_postfix) { 'AddressWrapper address' }
    
      it { member_variable(address).should === loose_value }
      it { member_variable(address_with_default).should === loose_value }

      it { member_variable(address_is_required).should === strict_value }
      it { member_variable(address_is_required_with_default).should === strict_value }
    end
  end


  def method_signature(type, name, arguments, body)
    "public final #{type} #{name}(#{arguments.join(', ')}) { #{body}; }"
  end
  
  describe "getter" do
    it { getter(car).should === method_signature('String', 'getCar', [], 'return null != this.car ? this.car : getCarDefault()') }

    it { getter(address).should === method_signature('AddressWrapper', 'getAddress', [], 'return null != this.address ? this.address : getAddressDefault()') }
  end


  describe "setter" do
    it { setter(car).should === method_signature('String', 'setCar', ['String _car'], 'return this.car = _car') }

    it { setter(address).should === method_signature('AddressWrapper', 'setAddress', ['AddressWrapper _address'], 'return this.address = _address') }
  end


  describe "default" do
    it { default(car).should === method_signature('String', 'getCarDefault', [], 'return null') }

    it { default(car_with_default).should === method_signature('String', 'getCarDefault', [], 'return "Subaru"') }
  end  
end
