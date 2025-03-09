class TodosController < ApplicationController
  def index
    @todos = Todo.pending_todos
  end

  def new
    @todo = Todo.new
  end

  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      redirect_to todos_path, notice: 'Todoが正常に作成されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :description)
  end
end
