require 'rails_helper'

RSpec.describe "Todo対応完了", type: :system do
  before do
    driven_by :playwright
  end

  let!(:todo) { create(:todo, :pending, title: "テスト用Todo") }

  describe "対応完了ボタンのクリック" do
    before do
      visit todos_path
    end

    context "確認ダイアログで「キャンセル」をクリックした場合", js: true do
      it "Todoのステータスが変更されないこと" do
        # 対応完了ボタンをクリック（キャンセルを選択）
        page.dismiss_confirm("「テスト用Todo」を対応完了に変更しますか？") do
          click_button "対応完了"
        end

        # Todoが一覧に表示されたままであることを確認
        expect(page).to have_content("テスト用Todo")

        # データベース上でもステータスが変更されていないことを確認
        expect(todo.reload.status).to eq("pending")
      end
    end

    context "確認ダイアログで「OK」をクリックした場合", js: true do
      it "Todoのステータスが「completed」に変更され、一覧から削除されること" do
        # 対応完了ボタンをクリック（OKを選択）
        page.accept_confirm("「テスト用Todo」を対応完了に変更しますか？") do
          click_button "対応完了"
        end

        # ページがリロードされ、成功メッセージが表示されることを確認
        expect(page).to have_content("Todoを完了状態に更新しました。")

        # Todoが一覧から削除されていることを確認（ページリロード後）
        expect(page).not_to have_content("テスト用Todo")

        # データベース上でステータスが変更されていることを確認
        expect(todo.reload.status).to eq("completed")
      end
    end
  end
end
