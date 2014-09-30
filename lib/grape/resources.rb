require "grape"
require "grape/resources/version"

module Grape
  class API
    include Grape::Resources
    class << self
      def resources_for( clazz, methods=[:list, :get, :post, :put, :delete])
        raise Error("To use grape_resources on a given class it should inherit from ActiveRecord::Base.( at least for now buddy ;) )") unless clazz < ActiveRecord::Base
        
        plural_name = clazz.name.pluralize.underscore        
        resources plural_name.to_sym do
          Grape::Resources.list_endpoint_for( clazz, self ) if methods.include?(:list)
          yield if block_given?
        end

        Grape::Resources.load_singular_endpoints(clazz, self, methods)   
      end
    end
  end

  module Resources
    class << self

      def load_singular_endpoints( clazz, api_instance, methods)
        singular_name = singular_name_for clazz

        api_instance.resource singular_name.to_sym do
          Grape::Resources.get_endpoint_for( clazz, api_instance ) if methods.include?(:get)
          Grape::Resources.create_endpoint_for( clazz, api_instance ) if methods.include?(:post)        
          Grape::Resources.update_endpoint_for( clazz, api_instance ) if methods.include?(:put)               
          Grape::Resources.delete_endpoint_for( clazz, api_instance) if methods.include?(:delete)
        end
      end
      
      def list_endpoint_for(clazz, api_instance)
        api_instance.get do
          result = Grape::Resources.list(clazz, params)
          result
        end
      end

      def get_endpoint_for(clazz, api_instance)   
        singular_name = singular_name_for clazz  
        api_instance.get ":id" do
          result = Grape::Resources.find(clazz, params)
          error!( "#{singular_name} not found", 404) if result.nil?
          result
        end
      end

      def delete_endpoint_for(clazz, api_instance) 
        singular_name = singular_name_for clazz
        
        api_instance.delete ":id" do
          result = Grape::Resources.find(clazz, params)
          error!( "#{singular_name} not found", 404) if result.nil?
          result.destroy
        end
      end

      def create_endpoint_for(clazz, api_instance)
        singular_name = singular_name_for clazz
        api_instance.post do
          result = clazz.new
          
          Grape::Resources.apply_attributes(result, params)
          error!( {error: "#{singular_name} is not valid", errors: result.errors.full_messages}, 405) unless result.valid?
          
          result.save
        end
      end

      def update_endpoint_for(clazz, api_instance)
        singular_name = singular_name_for clazz

        api_instance.put ":id" do
          result = clazz.find_by_id(params[:id])        
          error!( {error: "#{singular_name} with id '#{params[:id]}' was not found"}, 404) unless result.present?
          
          Grape::Resources.apply_attributes(result, params)
          error!( {error: "#{singular_name} is not valid", errors: result.errors.full_messages}, 405) unless result.valid?
          
          result.save          
          result          
        end
      end

      def apply_attributes(instance, params)
        instance.attributes.each do |attribute|
          attribute_name = attribute[0]
          instance.send("#{attribute_name}=",params[attribute_name.to_sym]) if params[attribute_name.to_sym]           
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


