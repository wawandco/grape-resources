require 'grape'
require 'grape/resources'

class SampleAPI < Grape::API
  include Grape::Resources

  resources_for(User)
end