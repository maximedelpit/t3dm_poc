class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many :project_users
  has_many :projects, through: :project_users
  has_many :comments
  has_many :mentions

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
    # TO DO => remove since temporary
    self.entity = 'Max Corp'
    self.category = 'client'
  end

  def initials
    name.split().map {|word| word[0].capitalize}.join('')
  end
end
