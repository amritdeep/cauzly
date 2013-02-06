class NonProfit < ActiveRecord::Base
  belongs_to :user
  
  validates :non_profit_name ,:presence => true
  
end