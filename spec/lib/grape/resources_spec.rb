require 'spec_helper'
require 'support/examples/api_example'

describe Grape::Resources do
  subject { 
    Class.new(APIExample)
  }

  def app
    subject
  end

  describe "gem should ensure the class passed is a subclass of ActiveRecord::Base" do
    it "should raise an error if the class passed is not a subclass of ActiveRecord::Base" do
      clazz = Object.const_set("NotActiveRecord".classify, Class.new)
      expect{
        subject.resources_for(clazz)  
      }.to raise_error
    end
  end

  describe "routes adding feature" do
    
    before do      
      subject.resources_for(User)
      subject.format :json
    end

    it "should respond to [GET] /users.json" do    
      get "/users.json"
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

  describe "generated routes" do
    before do      
      subject.resources_for(User)      
    end

    it "[GET] /plural should return the list of elements" do
      user = create(:user)
      get "/users.json"
      expect( JSON.parse(last_response.body).size ).to eql User.count
    end
  end
end