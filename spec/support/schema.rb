ActiveRecord::Schema.define(version: 20140212210648) do

  create_table "users", force: true do |t|
    t.string 'name'
    t.string 'email'
  end
  
  create_table "cars", force: true do |t|
    t.string 'name'
    t.string 'model'
    t.integer 'weight'    
  end
end