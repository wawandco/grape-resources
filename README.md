[![Code Climate](https://codeclimate.com/github/wawandco/grape-resources.png)](https://codeclimate.com/github/wawandco/grape-resources)
[![Build Status](https://travis-ci.org/wawandco/grape-resources.svg?branch=config-adding-travis)](https://travis-ci.org/wawandco/grape-resources)
[![Test Coverage](https://codeclimate.com/github/wawandco/grape-resources/badges/coverage.svg)](https://codeclimate.com/github/wawandco/grape-resources)
# Grape::Resources

Grape-resources is an extension of the grape API framework that allows to scaffold easily models that could not contain much logic, it allows you also to specify wich of the REST methods to scaffold in case you dont want to generate those all.


## Installation

Add this line to your application's Gemfile:

    gem 'grape-resources'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install grape-resources

## Usage

Imagine you want to build the basic CRUD for one of your models inside your grap API, for the example lets say its called Player.

In your api/my_api.rb

```ruby

class MyApi::API < Grape::API
  resources_for(Player)
end

```
This should generate by default the following routes:

    GET     /players
    GET     /player/:id
    POST    /player
    PUT     /player/:id
    DELETE  /player/:id

In case you only want some of the routes you can specify these to the resource method like:

```ruby

class MyApi::API < Grape::API
  resources_for(Player, [:list, :get])
end

```

And again this should only generate the following routes:

    GET     /players
    GET     /player/:id

Available options for routes are:

    :list   -> [GET]    /players
    :get    -> [GET]    /player/:id
    :post   -> [POST]   /player
    :put    -> [PUT]    /player/:id
    :delete -> [DELETE  /player/:id

TODO: v0.0.2

- Detect when resources_for is being called inside another resource, in that case, generated routes should 
  consider the parent resource id.

  for example:

  ```ruby

    class MyApi::API < Grape::API
      resources :teams do
        resources_for(Player, [:list, :get])
      end
    end

  ```

  And it should generate: 

    GET     /team/:id/players
    GET     /team/:id/player/:id
    POST    /team/:id/player
    PUT     /team/:id/player/:id
    DELETE  /team/:id/player/:id

## Contributing

1. Fork it ( https://github.com/[my-github-username]/grape-resources/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
