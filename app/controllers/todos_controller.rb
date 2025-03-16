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
      redirect_to todos_path, notice: "Todoが正常に作成されました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @todo.update(todo_params)
      redirect_to todos_path, notice: "Todoが正常に更新されました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def complete
    @todo.completed!
    redirect_to todos_path, notice: "Todoを完了状態に更新しました。"
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description)
  end
end
