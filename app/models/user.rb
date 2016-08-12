class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :events, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]
  after_create :send_welcome_email

  mount_uploader :profile_img, AvatarUploader

  mount_uploader :header_img, ProfileBgUploader

  include Gravtastic
  gravtastic

  after_save do |user|  
    heroku_environments = %w(production staging)
    if user.domain && (heroku_environments.include? Rails.env)
      added = false
      heroku = Heroku::API.new(api_key: ENV['HEROKU_API_KEY'])
      heroku.get_domains(ENV['APP_NAME']).data[:body].each do |domain|
        added = true if domain['domain'] == user.domain
      end

      unless added
        heroku.post_domain(ENV['APP_NAME'], user.domain)
        heroku.post_domain(ENV['APP_NAME'], "www.#{user.domain}")
      end
    end
  end 

  private

    def send_welcome_email
      UserMailer.welcome_email(self)
    end


    def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.name = auth.info.name   # assuming the user model has a name
        user.image = auth.info.image # assuming the user model has an image
      end
    end

    def self.new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end






end
