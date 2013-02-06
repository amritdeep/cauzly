# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)






statesn = Array.new
statesn=["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District of Columbia","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]

code= Array.new
code=["AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
count=0
statesn.each do |st|
      State.create(:name=> st, :state_code => code[count])
      count+=1
end


array = Array.new
array=["Administrator","Individual","Nonprofits","Company"]

array.each do |a|
  UserType.create(:name=>a)
end

User.create(
:user_type_id => 1,
:email => "admin@cauzly.com",
:password => "admin1@admin",
:password_confirmation => "admin1@admin",
#:confirmation_token => nil
)

array = Array.new
array=["Animals","Arts and Culture","Education","Environment","Health","Human Services","International","Public Advocacy","Religion"]

array.each do |a|
  CampaignCategory.create(:name=>a)
end


