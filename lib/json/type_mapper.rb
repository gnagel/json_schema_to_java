require 'active_support/core_ext/object/blank'
require 'active_support/inflector/methods'

module Json
  class TypeMapper
    def self.parse(opts)
      map(opts[:type])
    end


    def self.map(value) 
      raise ArgumentError, "Invalid input value" if value.blank?
      
      value = ActiveSupport::Inflector.camelize(value, true)
      
      case value
      when 'Array'
        # TODO I will need to build pluralize'd version of this model
        ActiveSupport::Inflector.pluralize(value)
      when 'Boolean'
        value
      when 'Integer'
        value
      when 'Number'
        'Double'
      when 'Integer'
        value
      when 'String'
        value
      else
        value
      end
    end
  end
end