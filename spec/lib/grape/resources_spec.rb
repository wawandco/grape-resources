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
      user = create(:user)
      get "/user/#{user.id}"
      expect(last_response.status).to eql 200
    end

    it "should respond to [POST] /user" do
      post "/user", name: "Some name"
      expect(last_response.status).to eql 201
    end

    it "should respond to [PUT] /user/:id" do
      put "/user/1"
      expect(last_response.status).to eql 200
    end

    it "should respond to [DELETE] /user/:id" do
      user = create(:user)
      delete "/user/#{user.id}"
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

    it "[GET] /singular/:id should return the instance we're looking for" do
      user = create(:user)
      get "/user/#{user.id}.json"      
      expect( JSON.parse(last_response.body)["name"] ).to eql user.name
    end

    it "[GET] /singular/:id should return 404 if id doesnt match" do
      get "/user/#{12323}.json"
      expect( last_response.status ).to be 404
    end

    it "[DELETE] /singular/:id should delete the row with the same id" do
      user = create(:user)
      expect{
        delete "/user/#{user.id}"  
      }.to change{ User.count }
    end

    it "[DELETE] /singular/:id should return 404 if id not found" do
      delete "/user/#{12323}.json"
      expect( last_response.status ).to be 404
    end

    it "[DELETE] /singular/:id should return 404 if no id passed" do
      delete "/user"
      expect( last_response.status ).to be 405
    end

    it "[POST] /singular should return 405 if model validation returns false" do
      post "/user", email: "some@email.com"
      expect(last_response.status).to be 405
    end

    it "[POST] /singular should not create model if model validation returns false" do
      expect{
        post "/user", email: "some@email.com"
      }.not_to change{ User.count }      
    end

    it "[POST] /singular should return 201 if model was created" do
      post "/user", email: "some@email.com", name: "Juan Perez"
      expect(last_response.status).to be 201
    end

    it "[POST] /singular should create a new record of the instance" do
      expect{
        post "/user", email: "some@email.com", name: "Juan Perez" 
      }.to change{ User.count }      
    end

    it "[POST] /singular should create a new record of the instance" do
      post "/user", email: "some@email.com", name: "Something Special" 
      expect(User.last.name).to eql "Something Special"
    end

    it "[POST] /singular should return validation errors on the response.body" do
      post "/user"
      p last_response.body
      expect(last_response.body).to include("Name can't be blank")
    end


  end
end