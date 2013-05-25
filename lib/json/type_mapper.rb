require 'active_support/inflector/methods'

module Json
  class TypeMapper
    def self.map(value) 
      value = ActiveSupport::Inflector.camelize(value, true)
      
      case value
      when 'Array'
        'ArrayList'
      when 'Boolean'
        value
      when 'Integer'
        value
      when 'Number'
        value
      when 'String'
        value
      else
        value
      end
    end
  end
end