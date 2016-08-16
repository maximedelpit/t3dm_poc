class Project < ApplicationRecord
  include Statesman::Adapters::ActiveRecordQueries

  # TO DO => check Trello for models assoc. & valid. to add
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  has_many :specs, dependent: :destroy
  has_one :purpose
  has_one :material
  has_one :heat_treatment
  has_one :surface
  has_one :dimension
  has_one :quality_control
  has_many :topics
  has_many :transitions, class_name: "ProjectTransition", autosave: false


  # validates :state, :cycle, presence: true
  validates :title, :client, :measurement_unit, presence: true
  validates :length, :width, :height, :min_wall_thickness, :github_owner,
            :min_hole_diameter, :max_pipe_diameter, presence: true

  validates :length, :width, :numericality => { greater_than: 0, less_than_or_equal_to: BigDecimal.new(250)} # TO DO => if not only mm => convertor
  validates :height, :numericality => { greater_than: 0, less_than_or_equal_to: BigDecimal.new(300)} # TO DO => if not only mm => convertor
  validates :min_wall_thickness, :numericality => { greater_than_or_equal_to: BigDecimal.new(0.2, 3)} # TO DO => if not only mm => convertor
  validates :min_hole_diameter, :numericality => { greater_than_or_equal_to: BigDecimal.new(0.3, 3)} # TO DO => if not only mm => convertor
  validates :max_pipe_diameter, :numericality => { greater_than: 0, less_than: BigDecimal.new(0.8, 3)} # TO DO => if not only mm => convertor
  validates :impossible_details, :trapped_volumes, inclusion: {in: [false], allow_nil: false}


  validates :thales_id, presence: true, uniqueness: true
  validates :repo_id, presence: true, uniqueness: true, on: :update
  validate :minimal_specs_presence

  accepts_nested_attributes_for :specs, :purpose, :material, :heat_treatment,
                                :surface, :dimension, :quality_control,
                                reject_if: :all_blank, allow_destroy: true

  scope :in_phasis, -> (filter) {in_state(self.send(filter)).distinct}

  include Project::ExternalInput

  def minimal_specs_presence
    check_spec_standards # to do
    true
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

  def check_spec_standards
    Spec::TYPE.each do | type |
      spec = self.send(type.underscore)
      spec.standard = spec.check_if_standard if spec
    end
  end

  def repo_name
    "#{thales_id}-#{title.gsub(' ','-')}"
  end

  def repo_uri
    "#{github_owner}/#{repo_name}"
  end

  # STATE MACHINE METHODS
  def state_machine
    @state_machine ||= ProjectStateMachine.new(self, transition_class: ProjectTransition,
                                                     association_name: :transitions)
  end

  def self.transition_name
    :transitions
  end

  def self.transition_class
    ProjectTransition
  end
  private_class_method :transition_class

  def self.initial_state
    :pending
  end
  private_class_method :initial_state

  def self.feasibility
    [:pending, :design_analysis, :feasibility]
  end

  def self.bid
    [:bid, :pricing_estimates, :bid_review]
  end

  def self.production
    [ :planning, :production, :production_orders, :finishing, :quality_control,
      :payment, :shipping, :satisfaction ]
  end
end
