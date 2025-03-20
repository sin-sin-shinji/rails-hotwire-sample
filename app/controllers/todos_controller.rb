class TodosController < ApplicationController
  before_action :set_todo, only: [ :edit, :update, :complete ]

  def index
    @todos = Todo.pending_todos
  end

  def new
    @todo = Todo.new
  end

  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      # Todo一覧を再取得
      @todos = Todo.pending_todos
      # ページ内容へ反映
      respond_to do |format|
        format.html { redirect_to todos_path, notice: "Todoが正常に作成されました。" }
        format.turbo_stream { flash.now.notice = "Todoが正常に作成されました。" }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @todo.update(todo_params)
      respond_to do |format|
        format.html { redirect_to todos_path, notice: "Todoが正常に更新されました。" }
        format.turbo_stream { flash.now.notice = "Todoが正常に更新されました。" }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def complete
    @todo.completed!
    flash.now.notice = "Todoを完了状態に更新しました。"
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description)
  end
end
