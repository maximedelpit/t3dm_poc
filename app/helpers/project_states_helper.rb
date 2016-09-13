module ProjectStatesHelper
  def prod_history_states
    # TO DO make it SQL
    @project.state_machine.history.pluck(:to_state).uniq.select do | h_s |
      ProjectStateMachine.production.include?(h_s.to_sym)
    end
  end

  def prod_state_monitoring
    prod_history = prod_history_states
    prod_states_hash =  {}
    ProjectStateMachine.production.each do | state |
      prod_states_hash[state] = prod_history.include?(state.to_s)
    end
    return prod_states_hash
  end

  def state_status(state_machine, state)
    if state.to_s == @state_machine.current_state
      return 'Pending'
    elsif prod_history_states.include?(state.to_s)
      return 'Done'
    else
      return 'To Do'
    end
  end

  def co_engineering_icons
    return {
      adapt_and_finalize: 'settings',
      design_analysis: 'lightbulb_outline',
      quotation: 'show_chart',
      bid: 'euro_symbol'
    }
  end


  def production_icons
    return {
      preparation: 'assignment',
      printing: 'print',
      heat_treatment: 'whatshot',
      cutting: 'content_cut',
      machining: 'open_with', #settings_overscan
      finishes: 'sync',
      surface_treatment: 'subject',
      quality_control: 'equalizer',
      shipping: 'local_shipping'
    }
  end
end
