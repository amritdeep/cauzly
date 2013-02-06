class ApiNonprofit < ActiveRecord::Base
   has_one :donation,:as => :donatable
   accepts_nested_attributes_for :donation, :allow_destroy => :true
end
