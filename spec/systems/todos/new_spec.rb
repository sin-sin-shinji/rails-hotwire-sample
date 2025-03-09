require 'rails_helper'

RSpec.describe "Todo新規作成", type: :system do
  before do
    driven_by :playwright
  end

  describe "新規作成ページへの遷移" do
    it "一覧画面の「新規追加」リンクをクリックすると、新規作成ページへ遷移すること" do
      visit todos_path
      click_link "新規追加"

      expect(page).to have_current_path(new_todo_path)
      expect(page).to have_content("新規Todo作成")
    end
  end

  describe "Todo新規作成" do
    before do
      visit new_todo_path
    end

    context "有効なデータを入力した場合" do
      it "Todoが作成され、一覧画面にリダイレクトされ、成功メッセージが表示されること" do
        # フォームに入力
        fill_in "タイトル", with: "新しいTodo"
        fill_in "内容", with: "これは新しいTodoの説明です。"

        # 作成ボタンをクリック
        click_button "作成"

        # 一覧画面にリダイレクトされることを確認
        expect(page).to have_current_path(todos_path)

        # 成功メッセージが表示されることを確認
        expect(page).to have_content("Todoが正常に作成されました。")

        # 作成したTodoが表示されることを確認
        expect(page).to have_content("新しいTodo")
        expect(page).to have_content("これは新しいTodoの説明です。")

        # データベースに保存されていることを確認
        todo = Todo.find_by(title: "新しいTodo")
        expect(todo).not_to be_nil
        expect(todo.description).to eq("これは新しいTodoの説明です。")
        expect(todo.status).to eq("pending")
      end
    end

    context "タイトルが空の場合" do
      it "エラーメッセージが表示され、新規作成ページが再表示されること" do
        # 送信前のTodo件数を記録
        todo_count_before = Todo.count

        # 内容のみ入力
        fill_in "内容", with: "これは新しいTodoの説明です。"

        # 作成ボタンをクリック
        click_button "作成"

        # 新規作成ページが再表示されることを確認
        expect(page).to have_current_path(/\/todos(\/new)?$/)
        expect(page).to have_content("新規Todo作成")

        # エラーメッセージが表示されることを確認
        expect(page).to have_content("入力内容に1個のエラーがあります")
        expect(page).to have_content("タイトルを入力してください")

        # データベースに保存されていないことを確認（レコード件数が増えていないこと）
        expect(Todo.count).to eq(todo_count_before)
      end
    end
  end
end
