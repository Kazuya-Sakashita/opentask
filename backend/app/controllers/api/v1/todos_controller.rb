class Api::V1::TodosController < ApplicationController
  before_action :set_todo, only: %i[show update destroy]

  def index
    todos = policy_scope(Todo)

    render json: todos
  end

  def show
    authorize @todo

    render json: @todo
  end

  def create
    todo = current_user.todos.build(todo_params)

    authorize todo

    if todo.save
      render json: todo, status: :created
    else
      render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize @todo

    if @todo.update(todo_params)
      render json: @todo
    else
      render json: { errors: @todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @todo

    @todo.soft_delete!

    head :no_content
  end

  private

  def set_todo
    @todo = Todo.active.find_by!(public_id: params[:public_id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :completed)
  end
end
