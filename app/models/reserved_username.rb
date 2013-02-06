class ReservedUsername < ActiveRecord::Base
  
 validates :username,:uniqueness => { :case_sensitive => false },:length => 2..36,:format=>{ :with => /^[a-zA-Z0-9_]*$/,:message => "can't contain any spaces and punctuations."}
 
   validate :check_profile_name
   
   
   def check_profile_name
     user =  User.find_by_profile_name(username)
     if user
      errors.add(:username," has already been used by a user.")
     end
   end
  
#  def self.create_reserved_names
#    excelfile = "runames.ods"
    
    
#    oo = Openoffice.new(excelfile)
#   oo.default_sheet = oo.sheets.first
#   1.upto(oo.last_row) do |line|
                  #1.upto(8) do |line|
#    reserved_name       = oo.cell(line,'A')
#    if reserved_name
#      puts "#{reserved_name}..|.."
#      ReservedUsername.create(:username => reserved_name.to_s)
#    end
#  end
    
    
#  end
  
end
