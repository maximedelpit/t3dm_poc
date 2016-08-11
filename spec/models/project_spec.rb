require "rails_helper"

RSpec.describe Project, :type => :model do
  # before { @project = FactoryGirl.build(:project) } # build does not create in database
  # subject { @project }
  context 'Check validation exhaustivity at create' do
    [ :title, :length, :width, :height, :min_wall_thickness, :min_hole_diameter,
      :max_pipe_diameter, :thales_id,
      :client,:state, :cycle, :github_owner
    ].each do | attribute |
        it { should validate_presence_of( attribute )}
    end
    [ :length, :width, :height, :min_wall_thickness, :min_hole_diameter,
      :max_pipe_diameter
    ].each do | attribute |
      it { should validate_numericality_of( attribute )}
    end
    it { should validate_uniqueness_of( :thales_id )}
  end

  context 'Ensure project is valid at create' do
    #   it "has one title" do
    #   actual_project = FactoryGirl.create(:project)
    #   expect(actual_project).to eq([chelimsky, lindeman])
  end
end
