require "grape"
require "grape/resources/version"

module Grape
  class API
    include Grape::Resources
    class << self
      def resources_for( clazz )
        singular_name = clazz.name.underscore
        plural_name   = clazz.name.pluralize.underscore

        raise Error("To use grape_resources on a given class it should inherit from ActiveRecord::Base.( at least for now buddy ;) )") unless clazz < ActiveRecord::Base

        Grape::Resources.list_endpoint_for( clazz, self )
        Grape::Resources.get_endpoint_for( clazz, self )
        Grape::Resources.create_endpoint_for( clazz, self )
        
                
        route('PUT', ["/#{singular_name}/:id"], {})
        Grape::Resources.delete_endpoint_for(clazz, self)
      end
    end
  end

  module Resources
    class << self
      
      def list_endpoint_for(clazz, api_instance)
        plural_name   = clazz.name.pluralize.underscore

        api_instance.route('GET', ["/#{plural_name}"], {} ) do                   
          result = Grape::Resources.list(clazz, params)
          result
        end
      end

      def get_endpoint_for(clazz, api_instance)      
      singular_name = singular_name_for clazz  
        api_instance.route('GET', ["/#{singular_name }/:id"], {}) do
          result = Grape::Resources.find(clazz, params)
          error!( "#{singular_name} not found", 404) if result.nil?
          result
        end
      end

      def delete_endpoint_for(clazz, api_instance) 
      singular_name = singular_name_for clazz
        
        api_instance.route('DELETE', ["/#{singular_name}/:id"], {}) do
          result = Grape::Resources.find(clazz, params)
          error!( "#{singular_name} not found", 404) if result.nil?
          result.destroy
        end
      end

      def create_endpoint_for(clazz, api_instance)
        singular_name = singular_name_for clazz
        api_instance.route('POST', ["/#{singular_name}"], {}) do
          result = clazz.new
          
          result.attributes.each do |attribute|
            attribute_name = attribute[0]
            result.send("#{attribute_name}=",params[attribute_name.to_sym])            
          end

          error!( {error: "#{singular_name} is not valid", errors: result.errors.full_messages}, 405) unless result.valid?
          result.save
        end
      end

      def list(clazz, params)
        result = clazz.all
      end

      def find(clazz, params)
        result = clazz.find_by_id( params[:id])
      end

      def singular_name_for( clazz ) 
        clazz.name.underscore
      end
    end
  end
end


