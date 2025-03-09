require 'rails_helper'

RSpec.describe Todo, type: :model do
  describe 'バリデーション' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:position) }
    it { should validate_numericality_of(:position).only_integer }
  end

  describe 'enum' do
    it { should define_enum_for(:status).with_values(pending: 0, completed: 1) }

    context 'デフォルトのstatus' do
      let(:todo) { create(:todo) }

      it 'pendingであること' do
        expect(todo.status).to eq('pending')
      end
    end

    context 'statusの変更' do
      let(:todo) { create(:todo) }

      it 'completedに変更できること' do
        todo.completed!
        expect(todo.status).to eq('completed')
      end
    end
  end

  describe 'スコープ' do
    let(:pending_todo1) { create(:todo, :pending, position: 1) }
    let(:pending_todo2) { create(:todo, :pending, position: 2) }
    let(:completed_todo1) { create(:todo, :completed, position: 3) }
    let(:completed_todo2) { create(:todo, :completed, position: 4) }

    before do
      pending_todo1
      pending_todo2
      completed_todo1
      completed_todo2
    end

    describe '.pending_todos' do
      it '未対応のTodoを取得すること' do
        expect(Todo.pending_todos).to match_array([ pending_todo1, pending_todo2 ])
      end

      it '位置順に並んでいること' do
        expect(Todo.pending_todos.to_a).to eq([ pending_todo1, pending_todo2 ])
      end
    end

    describe '.completed_todos' do
      it '終了済みのTodoを取得すること' do
        expect(Todo.completed_todos).to match_array([ completed_todo1, completed_todo2 ])
      end

      it '位置順に並んでいること' do
        expect(Todo.completed_todos.to_a).to eq([ completed_todo1, completed_todo2 ])
      end
    end

    describe '.ordered' do
      it '位置順に並んでいること' do
        expect(Todo.ordered.to_a).to eq([ pending_todo1, pending_todo2, completed_todo1, completed_todo2 ])
      end
    end
  end
end
