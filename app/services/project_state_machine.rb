class ProjectStateMachine
  include Statesman::Machine

  STATES = [ :pending, :design_analysis, :feasability, :bid, :pricing_estimates,
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
  before_transition(from: :bid_review, to: :planning ) do |project, transition|
    project.update(cycle: 'co-engineering')
  end
  before_transition(from: :planning, to: :bid_review ) do |project, transition|
    project.update(cycle: 'co-engineering')
  end


  # state :pending, initial: true
  # state :design_analysis
  # state :feasability
  # state :bid
  # state :pricing_estimates
  # state :bid_review
  # state :planning
  # state :production
  # state :production_orders
  # state :finishing
  # state :quality_control
  # state :payment
  # state :shipping
  # state :satisfaction

  def states
    STATES
  end
end
