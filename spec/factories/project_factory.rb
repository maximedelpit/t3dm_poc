FactoryGirl.define do
  factory :project do
    title "Test-Upload"
    measurement_unit "mm"
    length BigDecimal.new(250)
    width BigDecimal.new(250)
    height BigDecimal.new(300)
    min_wall_thickness BigDecimal.new(0.2, 3)
    min_hole_diameter BigDecimal.new(0.3, 3)
    max_pipe_diameter BigDecimal.new(0.7, 3)
    impossible_details false
    trapped_volumes false
    thales_id "T3DM0001"
    client "Dassault"
    state "pending"
    cycle "co-engineering"
    github_owner "maximedelpit"
  end
end




