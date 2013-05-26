require_relative '../spec_helper.rb'

describe Json::TypeMapper do
  
  it { expect{ Json::TypeMapper.map(nil) }.to raise_error ArgumentError }
  it { expect{ Json::TypeMapper.map('') }.to raise_error ArgumentError }
  it { Json::TypeMapper.map('boolean').should eq 'Boolean' }
  it { Json::TypeMapper.map('array').should eq 'ArrayList' }
  it { Json::TypeMapper.map('number').should eq 'Double' }
  it { Json::TypeMapper.map('integer').should eq 'Integer' }
  it { Json::TypeMapper.map('string').should eq 'String' }
  it { Json::TypeMapper.map('random_class_name').should eq 'RandomClassName' }
  
end