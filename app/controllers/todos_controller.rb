class TodosController < ApplicationController
  before_action :set_todo, only: [ :edit, :update ]

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

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description)
  end
end
