class OrdersController < ApplicationController
  before_action :find_project, only: [:create, :update]
  before_action :find_order, only: :update

  def create
    @order = Order.new(order_params)
    skip_authorization
    @order.order_lines.each { |ol| ol.project_id =  @project.id}
    @order.state = 'pending'
    ProjectStateMachine.production[0..-3].each do |state|
      @order.order_lines.build(description: state.to_s.gsub('_', ' ').capitalize, project_id: @project.id)
    end
    @project.update(due_date: @order.due_date)
    @state_machine = @project.state_machine
    @order.save
  end

  def update
    @order.update(order_params)
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_order
    @order = Order.find(params[:id])
    authorize @order
  end

  def order_params
    # TO DO => change generation with project order items... and remove project_id hidden_fields
    params.require(:order).permit(  :due_date, :quantity, :price, :state, :review, :rating,
                                    order_lines_attributes: [:id, :description, :unit_price, :duration, :project_id, :_destroy]
                                )
  end
end
