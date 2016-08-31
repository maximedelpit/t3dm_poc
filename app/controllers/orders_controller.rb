class OrdersController < ApplicationController
  before_action :find_project, only: [:create, :update]
  before_action :find_order, only: :update

  def create
    @order = Order.new(order_params)
    @order.state = 'pending'
    binding.pry
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
  end

  def order_params
    # TO DO => change generation with project order items... and remove project_id hidden_fields
    params.require(:order).permit(  :due_date, :quantity, :price, order_lines_attributes: [
                                      :id, :description, :unit_price, :duration, :project_id, :_destroy
                                    ]
                                  )
  end
end
