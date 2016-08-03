class Project < ApplicationRecord
  # TO DO => check Trello for models assoc. & valid. to add
  has_many :project_users
  has_many :users, through: :project_users
  has_many :specs
  has_many :topics

  validates :title, :client, :state, :cycle, :measurement_unit, presence: true
  validates :length, :width, :height, :min_wall_thickness,
            :min_hole_diameter, :max_pipe_diameter, presence: true

  validates :length, :width, :numericality => { greater_than: 0, less_than_or_equal_to: BigDecimal.new(250)} # TO DO => if not only mm => convertor
  validates :height, :numericality => { greater_than: 0, less_than_or_equal_to: BigDecimal.new(300)} # TO DO => if not only mm => convertor
  validates :min_wall_thickness, :numericality => { greater_than_or_equal_to: BigDecimal.new(0.2)} # TO DO => if not only mm => convertor
  validates :min_hole_diameter, :numericality => { greater_than_or_equal_to: BigDecimal.new(0.3)} # TO DO => if not only mm => convertor
  validates :max_pipe_diameter, :numericality => { greater_than: 0, less_than: BigDecimal.new(0.8)} # TO DO => if not only mm => convertor

  validates :thales_key, presence: true, uniqueness: true
  validates :repo_id, presence: true, uniqueness: true, on: :update
  validate :minimal_specs_presence

  t.string   "measurement_unit"
    t.decimal  "length"
    t.decimal  "width"
    t.decimal  "height"
    t.decimal  "min_wall_thickness"
    t.decimal  "min_hole_diameter"
    t.decimal  "max_pipe_diameter"
    t.boolean  "impossible_details"
    t.boolean  "trapped_volumes"
    t.string   "repo_id"
    t.string   "thales_key"

  def minimal_specs_presence
    true # to do
  end

  def clients
    users.where(catergory: 'client')
  end

  def productors
    users.where(catergory: 'productor')
  end

  def method_officors
    users.where(catergory: 'method officors')
  end
end
