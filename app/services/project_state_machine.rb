class ProjectStateMachine
  include Statesman::Machine

  STATES = [ :pending, :design_analysis, :feasibility, :bid, :pricing_estimates,
             :bid_review, :planning, :production, :production_orders, :finishing,
             :quality_control, :payment, :shipping, :satisfaction
  ]

  STATES.each do | value |
    if value == :pending
      state value, initial: true
    else
      state value
    end
  end

  STATES.each_with_index do | state, index |
    prev_state = STATES[index - 1]
    next_state = STATES[index + 1]
    if index == 0
      transition from: state, to: [next_state]
    elsif index == STATES.size - 1
      transition from: state, to: [prev_state]
    else
      transition from: state, to: [next_state, prev_state ]
    end
  end

  before_transition(to: :pending) do |project, transition|
    project.update(cycle: 'co-engineering')
  end
  before_transition(from: :pending, to: :design_analysis) do |project, transition|
    # TO DO: create feasibility branch
  end
  after_transition(from: :design_analysis, to: :feasibility) do |project, transition|
    # TO DO: merge feasibility branch to master
  end
  before_transition(from: :feasibility, to: :bid) do |project, transition|
    # TO DO: create bid branch
  end
  before_transition(from: :bid, to: :pricing_estimates) do |project, transition|
    # TO DO: ???? Pull request & commits
  end
  after_transition(from: :pricing_estimates, to: :bid_review) do |project, transition|
    # TO DO: merge bid branch to master
  end
  before_transition(from: :bid_review, to: :planning ) do |project, transition|
    # TO DO: create production branch
    project.update(cycle: 'production')
  end
  # ... TO DO => anything to do therer?
  after_transition(from: :quality_control, to: :payment ) do |project, transition|
    # TO DO: merge production branch to master
  end
  before_transition(from: :planning, to: :bid_review ) do |project, transition|
    project.update(cycle: 'co-engineering')
  end

  def ordered_states
    STATES
  end

  def next
    current_index = STATES.find_index(current_state.to_sym)
    next_state = STATES[current_index + 1]
    can_transition_to?(next_state) ? transition_to!(next_state) : raise
  end

  def previous
    current_index = STATES.find_index(current_state.to_sym)
    previous_state = STATES[current_index - 1]
    can_transition_to?(previous_state) ? transition_to!(previous_state) : raise
  end

  def self.feasibility
    [:pending, :design_analysis, :feasibility]
  end

  def self.bid
    [:bid, :pricing_estimates, :bid_review]
  end

  def self.production
    [ :planning, :production_orders, :manufacturing, :finishing, :quality_control,
      :payment, :shipping, :satisfaction ]
  end

  def self.production_manufacturing
    [:finishing, :quality_control]
  end

  def self.production_finalizing
    [:payment, :shipping, :satisfaction]
  end

  def phasis
    state_sym = current_state.to_sym
    if in_state?(self.class.feasibility)
      return "Adapt & Finalize"
    elsif in_state?(self.class.bid)
      return "Bid"
    elsif in_state?(self.class.production) && self.class.production.find_index(state_sym) < 2
      return "Analisys"
    elsif in_state?(self.class.production) && self.class.production.find_index(state_sym) > 4
      return "Finalizing"
    else
      return "Manufacturing"
    end
  end

  def current_base_branch
    # does not deal with back to prev state since
    state = current_state.to_sym
    if [:pending, :bid_review, :payment, :shipping, :satisfaction].include?(state)
      return "master"
    elsif state == :design_analysis
      return 'feasability'
    elsif state == :bid || state == :pricing_estimates
      return 'bid'
    elsif [ :planning, :production_orders, :manufacturing, :finishing, :quality_control].include?(state)
      return "production"
    end
  end
end
