require_relative '../../spec_helper.rb'
require 'json'

describe Json::Models::ForeignCollectionOfFactory do
  let(:factory) { Json::Models::ForeignCollectionOfFactory.new(parent_type: 'vehicle', child_type: 'car') }
  
  it { factory.parent_type.should === 'Vehicle' }
  it { factory.child_type.should === 'Car' }
  it { factory.collection_type.should === 'VehicleForeignCollectionOfCars' }
end
