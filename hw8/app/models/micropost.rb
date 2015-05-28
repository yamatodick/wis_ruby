class Micropost < ActiveRecord::Base
belongs_to :user
mount_uploader :picture, PictureUploader
validates :content, :presence => true, :length => { :maximum => 140 }
validates :user_id, :presence => true
validate :picture_size
	default_scope -> {order(created_at: :desc)}

	def picture_size
		if picture.size > 5.megabytes
			errors.add(:picture, "should be less than 5 MB")
		end
	end
end
