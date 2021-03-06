class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include PublicActivity::Model
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many :project_users
  has_many :projects, through: :project_users
  has_many :comments
  has_many :mentions
  has_many :attendees
  has_many :meetings, through: :attendees

  validates :token, :uid, :github_login, :name, :category, :entity, presence: true
  validates :token, :uid, :email, uniqueness: true

  after_initialize :set_entity

  def self.find_for_github_oauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.github_login = auth.extra.raw_info.login
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.name = auth.info.name
      user.picture = auth.info.image
      user.token = auth.credentials.token
    end
  end

  def set_entity
    if self.category.nil?
      self.entity = 'T3DM POC Team'
      if email.include?('production')
        self.category = 'production'
      elsif email.include?('methods')
        self.category = 'methods'
      elsif email.include?('engineering')
        self.category = 'client'
      end
    end
  end

  def initials
    name.split().map {|word| word[0].capitalize}.join('')
  end
end
