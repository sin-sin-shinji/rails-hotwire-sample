# == Schema Information
#
# Table name: todos
#  id          :bigint           not null, primary key
#  title       :string           not null              # Todoのタイトル
#  description :text                                   # Todoの詳細説明
#  status      :integer          default: 0            # ステータス（0: 未対応, 1: 終了済み）
#  position    :integer          not null              # 表示順序
#  created_at  :datetime         not null, limit: 6
#  updated_at  :datetime         not null, limit: 6
#
class Todo < ApplicationRecord
  # Enum定義
  enum :status, [ :pending, :completed ]

  # バリデーション
  validates :title, presence: true
  validates :position, presence: true, numericality: { only_integer: true }

  # コールバック
  before_validation :set_position, on: :create

  # スコープ
  scope :pending_todos, -> { where(status: :pending).order(position: :asc) }
  scope :completed_todos, -> { where(status: :completed).order(position: :asc) }
  scope :ordered, -> { order(position: :asc) }

  private

  def set_position
    self.position = Todo.maximum(:position).to_i + 1
  end
end
