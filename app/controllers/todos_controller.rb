class TodosController < ApplicationController
  def index
    @todos = Todo.pending_todos
  end
end
