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
      user = create :user
      put "/user/#{user.id}"
      expect(last_response.status).to eql 200
    end

    it "should respond to [DELETE] /user/:id" do
      user = create(:user)
      delete "/user/#{user.id}"
      expect(last_response.status).to eql 200
    end
  end

  describe "GET endpoint" do
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
  end

  describe "POST endpoint" do
    before do      
      subject.resources_for(User)      
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
      expect(last_response.body).to include("Name can't be blank")
    end    
  end

  describe "PUT endpoint" do
    before do      
      subject.resources_for(User)      
    end

    it "[PUT] /singular/:id should respond 404 if passed id doesnt correspond to valid entity" do
      put "/user/23888383", name: "Juan", email: "some@email"
      expect(last_response.status).to eql 404
    end

    it "[PUT] /singular/:id should 200 if passed id correspond to an existing entity" do
      user = create(:user)
      put "/user/#{user.id}", name: "Juan", email: "some@email"
      expect(last_response.status).to eql 200
    end

    it "[PUT] /singular/:id should update existing entity we passed the id on the route" do
      user = create(:user)
      put "/user/#{user.id}", name: "Juan", email: "some@email"
      expect(user.reload.name).to eql("Juan")
    end

    it "[PUT] /singular/:id should respond 405 if passed parameters cause broke validation" do
      user = create(:user)
      put "/user/#{user.id}", name: "", email: "some@email"
      expect( last_response.status).to eql(405)
    end
  end

  describe "DELETE endpoint" do
    before do      
      subject.resources_for(User)      
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

  end

  describe "endpoints selection" do
    before do      
      subject.resources_for(User, [:get] )          
    end

    it "should respond 200 to the GET endpoint" do
      user = create :user
      get "/user/#{user.id}"
      expect(last_response.status).to eql(200)
    end

    it "should respond 404 to the DELETE endpoint" do
      user = create :user
      delete "/user/#{user.id}"
      expect(last_response.status).to eql(405)
    end
     
  end

  describe "it should be able to handle 2 or more resources with different actions" do
    before do      
      subject.resources_for(User, [:get] )          
      subject.resources_for(Car)
    end

    it "should respond 200 to the GET endpoint" do
      user = create :user
      get "/user/#{user.id}"
      expect(last_response.status).to eql(200)
    end

    it "should respond 404 to the DELETE endpoint" do
      user = create :user
      delete "/user/#{user.id}"
      expect(last_response.status).to eql(405)
    end


    it "should respond to the DELETE endpoint with a 201" do
      car = create :car
      expect{
        delete "/car/#{car.id}"  
      }.to change{Car.count}            
    end
    
  end

  describe "block processing" do
    it "should accept a block and process it after the resources part" do
      
      subject.class_eval do
        resources_for(Car, [:list] ) do
          get :engine do
            ["Cars usually have one engine"]
          end
        end
      end

      get "/cars/engine"
      expect(last_response.status).to eq 200
    end
  end
end