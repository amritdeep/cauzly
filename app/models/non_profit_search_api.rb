class NonProfitSearchApi < ActiveRecord::Base
  
  def self.columns() @columns ||= []; end
 
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end
  
 
 
 def self.search(ein)
  firstgiving_url = FIRST_GIVING_SEARCH_URL + ein
  #puts firstgiving_url
  uri  = URI.parse(firstgiving_url)
  response =  Net::HTTP.get(uri)
  #puts response
  hashed_response =  Hash.from_xml(response)
  result = nil
 unless hashed_response["payload"].nil?
   unless hashed_response["payload"]["payload"].nil?
     unless hashed_response["payload"]["payload"]["key_0"].nil?
       
       result = hashed_response["payload"]["payload"]["key_0"]
     
     end
   end
 end
 end
 
  
 
end

