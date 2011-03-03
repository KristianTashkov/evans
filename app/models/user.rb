class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :trackable

  attr_accessible :password, :password_confirmation, :remember_me, :photo, :remove_photo

  mount_uploader :photo, PhotoUploader
end
