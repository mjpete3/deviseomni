class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
         
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  # lookup the user by email from facebook
  # store the facebook profile information in teh user table
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if user = User.find_by_email(data.email)
      user.last_name = data.last_name
      user.first_name = data.first_name
      user.provider = access_token.provider
      user.uid = access_token.uid
      user.location = data.location.name
      user.image = access_token.info.image
      user.profile = data.link
      user.timezone = data.timezone
      user.save
    else # Create a user with a stub password. 
      user = User.create!(:email => data.email, :password => Devise.friendly_token[0,20],
                   :last_name =>data.last_name, :fist_name => data.first_name, 
                   :provider => access_token.provider, :uid => access_token.uid,
                   :location => data.location.name, :image => access_token.info.image,
                   :profile => data.link, :timezone => data.timezone) 
    end
    return user
  end


end
