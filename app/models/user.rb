class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :remember_me, :provider, :uid, :oauth_token, :oauth_secret

  validates :username, presence: true

  def self.from_omniauth(auth, params)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.oauth_token = auth['credentials']['token']
      user.oauth_secret = auth['credentials']['secret']
      user.username = auth['info']['name'] || auth['info']['nickname']
      user.remember_me = true
    end
  end

end
