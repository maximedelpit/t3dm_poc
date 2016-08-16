require "rails_helper"

RSpec.describe ProjectStateMachine do
  DatabaseCleaner.strategy = :truncation, {:except => %w[users]}
  context 'State machine sequence' do
    before(:all) {
      DatabaseCleaner.clean
      @state_machine = FactoryGirl.create(:project).state_machine
    }
    subject {@state_machine}
    it 'is in pending state by default' do
      expect(subject.current_state).to eq("pending")
    end
    it 'can transition from state N to state N+1 excl. last ' do
      states = subject.ordered_states
      expect(
        states.all? do |state|
          index = states.find_index(state)
          if index != states.size - 1
            expect{ subject.transition_to!(states[index + 1])}.to_not raise_error
          else
            true
          end
        end
      ).to eq(true)
    end
    it 'can transition from state N to state N-1 excl first' do
      reverse_states = subject.ordered_states.reverse
      expect(
        reverse_states.all? do |state|
          index = reverse_states.find_index(state)
          if index != reverse_states.size - 1
            expect{ subject.transition_to!(reverse_states[index + 1])}.to_not raise_error
          else
            true
          end
        end
      ).to eq(true)
    end
  end
  context 'Project Cycle' do
    before(:all) {
      DatabaseCleaner.clean
      @state_machine = FactoryGirl.create(:project).state_machine
    }
    subject {@state_machine}
    it 'should set project cycle to Co-Engineering before pending state' do
      subject.class.after_transition(to: :pending) do |machine|
        expect(machine.object.cycle).to eq('co-engineering')
      end
    end
    it 'should set project cycle to Production before planning state' do
      subject.class.after_transition(from: :bid_review, to: :planning) do |machine|
        expect(machine.object.cycle).to eq('production')
      end
    end
    it 'should set project cycle to Co-Engineering before coming back from planning to bid_review' do
      subject.class.after_transition(from: :planning, to: :bid_review) do |machine|
        expect(machine.object.cycle).to eq('co-engineering')
      end
    end
  end

end
