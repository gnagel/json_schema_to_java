require 'hash_plus'
require 'symbolize_keys_recursively'
require 'uri'

require 'active_support/inflections'
require 'active_support/inflector/methods'

require_relative 'json/type_mapper'
require_relative "json/schema_to_java"
require_relative 'json/attributes/property_factory'
require_relative 'json/models/foreign_collection_of_factory'
