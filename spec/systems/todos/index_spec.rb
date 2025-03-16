require 'rails_helper'

RSpec.describe "Todos一覧", type: :system do
  before do
    driven_by :playwright
  end

  # 共通のsubject定義
  subject { visit todos_path }

  context "未対応のTodoが存在する場合" do
    before do
      # 未対応のTodoを3件作成
      create_list(:todo, 3, :pending)
      # 完了済みのTodoを2件作成（表示されないことを確認するため）
      create_list(:todo, 2, :completed)
    end

    it "未対応のTodoのみが表示されること" do
      subject

      # 見出しが表示されていることを確認
      expect(page).to have_content("未対応のTodo一覧")

      # 未対応のTodoが3件表示されていることを確認
      pending_todos = Todo.pending_todos
      expect(pending_todos.count).to eq(3)

      pending_todos.each do |todo|
        expect(page).to have_content(todo.title)
        expect(page).to have_content(todo.description) if todo.description.present?
      end

      # 完了済みのTodoが表示されていないことを確認
      completed_todos = Todo.completed_todos
      expect(completed_todos.count).to eq(2)

      completed_todos.each do |todo|
        expect(page).not_to have_content(todo.title)
      end
    end
  end

  context "未対応のTodoが存在しない場合" do
    before do
      # 完了済みのTodoのみを作成
      create_list(:todo, 2, :completed)
    end

    it "「未対応のTodoはありません」と表示されること" do
      subject

      expect(page).to have_content("未対応のTodoはありません")
    end
  end
end
