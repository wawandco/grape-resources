require 'spec_helper'

describe Grape::Resources do
  
  it "should work" do
    expect(1).to eq 1
  end
  
  it "should create a model" do
    user = create(:user)
    expect(user.class.name).to eq "User"
  end
  
end