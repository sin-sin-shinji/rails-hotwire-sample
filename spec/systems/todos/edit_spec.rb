require 'rails_helper'

RSpec.describe "Todo更新", type: :system do
  before do
    driven_by :playwright
  end

  let!(:todo) { create(:todo, title: "更新前のタイトル", description: "更新前の説明文") }

  describe "更新ページへの遷移" do
    it "一覧画面の「更新」リンクをクリックすると、更新ページへ遷移すること" do
      visit todos_path

      # aria-labelを使用してTodoアイテムを特定
      within "[aria-label='Todo: 更新前のタイトル']" do
        click_link "更新"
      end

      expect(page).to have_current_path(edit_todo_path(todo))
      expect(page).to have_content("Todo更新")

      # フォームに既存のデータが入力されていることを確認
      expect(page).to have_field("タイトル", with: "更新前のタイトル")
      expect(page).to have_field("内容", with: "更新前の説明文")
    end
  end

  describe "Todo更新" do
    before do
      visit edit_todo_path(todo)
    end

    context "有効なデータを入力した場合" do
      before do
        # フォームに入力
        fill_in "タイトル", with: "更新後のタイトル"
        fill_in "内容", with: "更新後の説明文"

        # 更新ボタンをクリック
        click_button "更新する"
      end

      it "画面表示が適切に変化すること" do
        # 一覧画面にリダイレクトされることを確認
        expect(page).to have_current_path(todos_path)

        # 成功メッセージが表示されることを確認
        expect(page).to have_content("Todoが正常に更新されました。")

        # 更新したTodoが表示されることを確認
        expect(page).to have_content("更新後のタイトル")
        expect(page).to have_content("更新後の説明文")
      end

      it "データベースの内容が更新されること" do
        # データベースが更新されていることを確認
        todo.reload
        expect(todo.title).to eq("更新後のタイトル")
        expect(todo.description).to eq("更新後の説明文")
      end
    end

    context "タイトルが空の場合" do
      before do
        # 更新前のTodo件数を記録
        @todo_count_before = Todo.count

        # タイトルを空にして内容のみ入力
        fill_in "タイトル", with: ""
        fill_in "内容", with: "更新後の説明文"

        # 更新ボタンをクリック
        click_button "更新する"
      end

      it "画面表示が適切に変化すること" do
        # 更新ページが再表示されることを確認
        expect(page).to have_current_path(/\/todos\/#{todo.id}(\/edit)?$/)
        expect(page).to have_content("Todo更新")

        # エラーメッセージが表示されることを確認
        expect(page).to have_content("入力内容に1個のエラーがあります")
        expect(page).to have_content("タイトルを入力してください")
      end

      it "データベースの内容が変更されないこと" do
        # データベースが更新されていないことを確認
        todo.reload
        expect(todo.title).to eq("更新前のタイトル")
        expect(todo.description).to eq("更新前の説明文")

        # Todo件数が変わっていないことを確認
        expect(Todo.count).to eq(@todo_count_before)
      end
    end
  end
end
