require 'rails_helper'

RSpec.describe "Todo新規作成", type: :system do
  before do
    driven_by :playwright
  end

  describe "モーダルでの新規作成" do
    it "一覧画面の「新規追加」リンクをクリックすると、モーダルが表示されること" do
      visit todos_path
      click_link "新規追加"

      # モーダルが表示されることを確認
      expect(page).to have_selector("dialog[open]")
      expect(page).to have_content("新規Todo作成")
    end
  end

  describe "Todo新規作成" do
    before do
      visit todos_path
      click_link "新規追加"
    end

    context "有効なデータを入力した場合" do
      before do
        # モーダル内のフォームに入力
        within "dialog" do
          fill_in "タイトル", with: "新しいTodo"
          fill_in "内容", with: "これは新しいTodoの説明です。"

          # 作成ボタンをクリック
          click_button "作成"
        end

        # モーダルが閉じるのを待つ
        expect(page).not_to have_selector("dialog[open]")
      end

      it "画面表示が適切に変化すること" do
        # 一覧画面に留まっていることを確認
        expect(page).to have_current_path(todos_path)

        # 成功メッセージが表示されることを確認
        expect(page).to have_content("Todoが正常に作成されました。")

        # 作成したTodoが表示されることを確認
        expect(page).to have_content("新しいTodo")
        expect(page).to have_content("これは新しいTodoの説明です。")
      end

      it "データベースに保存されること" do
        # データベースに保存されていることを確認
        todo = Todo.find_by(title: "新しいTodo")
        expect(todo).not_to be_nil
        expect(todo.description).to eq("これは新しいTodoの説明です。")
        expect(todo.status).to eq("pending")
      end
    end

    context "タイトルが空の場合" do
      before do
        # 更新前のTodo件数を記録
        @todo_count_before = Todo.count

        # モーダル内のフォームに入力
        within "dialog" do
          # タイトルを空にして内容のみ入力
          fill_in "タイトル", with: ""
          fill_in "内容", with: "これは新しいTodoの説明です。"

          # 作成ボタンをクリック
          click_button "作成"
        end
      end

      it "画面表示が適切に変化すること" do
        # モーダルが開いたままであることを確認
        expect(page).to have_selector("dialog[open]")

        # エラーメッセージが表示されることを確認
        within "dialog" do
          expect(page).to have_content("入力内容に1個のエラーがあります")
          expect(page).to have_content("タイトルを入力してください")
        end
      end

      it "データベースに保存されないこと" do
        # データベースに保存されていないことを確認（レコード件数が増えていないこと）
        expect(Todo.count).to eq(@todo_count_before)
      end
    end
  end

  describe "モーダルのキャンセル" do
    it "キャンセルボタンをクリックするとモーダルが閉じること" do
      visit todos_path
      click_link "新規追加"

      # モーダルが表示されることを確認
      expect(page).to have_selector("dialog[open]")

      # キャンセルボタンをクリック
      within "dialog" do
        click_link "キャンセル"
      end

      # モーダルが閉じることを確認
      expect(page).not_to have_selector("dialog[open]")

      # 一覧画面に留まっていることを確認
      expect(page).to have_current_path(todos_path)
    end
  end
end
