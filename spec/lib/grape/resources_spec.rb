require 'spec_helper'
require 'support/sample_api.rb'

describe Grape::Resources do
  subject { 
    Class.new(Grape::API)
  }

  def app
    subject
  end

  describe "routes adding feature" do
    
    before do
      subject.include Grape::Resources
      subject.resources_for(User)
    end

    it "should respond to [GET] /users" do    
      get "/users"
      expect(last_response.status).to eql 200
    end

    it "should respond to [GET] /user/:id" do
      get "/user/1"
      expect(last_response.status).to eql 200
    end

    it "should respond to [POST] /user" do
      post "/user"
      expect(last_response.status).to eql 201
    end

    it "should respond to [PUT] /user/:id" do
      put "/user/1"
      expect(last_response.status).to eql 200
    end

    it "should respond to [DELETE] /user/:id" do
      delete "/user/1"
      expect(last_response.status).to eql 200
    end
  end
end