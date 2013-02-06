class Asset < ActiveRecord::Base
   belongs_to :assetable, :polymorphic => true
validates_attachment_presence :attachment
end
