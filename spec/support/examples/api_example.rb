require "grape/resources"


class APIExample < Grape::API
  format :json
  resources_for( User )
end