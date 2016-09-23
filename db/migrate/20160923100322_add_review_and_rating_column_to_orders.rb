class AddReviewAndRatingColumnToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :review, :text
    add_column :orders, :rating, :integer
  end
end
