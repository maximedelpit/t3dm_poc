class ProjectStateMachine
  include Statesman::Machine

  STATES = [ :adapt_and_finalize, :design_analysis, :quotation, :bid, :preparation,
             :printing, :heat_treatment, :cutting, :machining, :finishes, :surface_treatment,
             :quality_control, :shipping, :payment, :satisfaction
  ]

  STATES.each do | value |
    if value == :adapt_and_finalize
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

  before_transition(to: :adapt_and_finalize) do |project, transition|
    project.update(cycle: 'co-engineering')
  end
  before_transition(from: :adapt_and_finalize, to: :design_analysis) do |project, transition|
    # TO DO: create design_analysis branch
  end
  after_transition(from: :design_analysis, to: :quotation) do |project, transition|
    # TO DO: merge design_analysis branch to master
    # TO DO: create quotation branch
  end
  after_transition(from: :quotation, to: :bid) do |project, transition|
    # TO DO: merge quotation branch to master
    # TO DO: create bid branch
    project.last_order.update(state: 'propal') if project.last_order.state == 'pending'
  end
  before_transition(from: :bid, to: :preparation ) do |project, transition|
    # TO DO: merge bid branch to master
    # TO DO: create production branch
    project.update(cycle: 'production')
  end
  # ... TO DO => anything to do therer?
  before_transition(from: :preparation, to: :bid ) do |project, transition|
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

  def self.co_engineering
    [:adapt_and_finalize, :design_analysis, :quotation, :bid]
  end

  def self.production
    [:preparation, :printing, :heat_treatment, :cutting, :machining, :finishes, :surface_treatment,
     :quality_control, :shipping, :payment]
  end

  def self.done
    [:satisfaction]
  end

  def current_base_branch
    # does not deal with back to prev state since
    state = current_state.to_sym
    if [:adapt_and_finalize, :payment, :satisfaction].include?(state)
      return "master"
    else
      return current_state
    end
  end
end
