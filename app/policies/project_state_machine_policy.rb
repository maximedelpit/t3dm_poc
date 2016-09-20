class ProjectStateMachinePolicy < ApplicationPolicy

  def update?
    record.object.users.include?(user) && verify_authorized_to_transit?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end


  private

  def verify_authorized_to_transit?
    case user.category
    when 'client' then [:adapt_and_finalize, :bid].include?(record.current_state.to_sym)
    when 'methods' then [:design_analysis, :quotation, :preparation].include?(record.current_state.to_sym)
    when 'production' then [:printing, :heat_treatment, :cutting, :machining, :finishes, :surface_treatment,
             :quality_control, :shipping, :payment, :satisfaction].include?(record.current_state.to_sym)
    when 'admin' then true
    else
      false
    end
  end
end
