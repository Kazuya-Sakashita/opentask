class TodoSerializer
  def self.call(todo)
    {
      public_id: todo.public_id,
      title: todo.title,
      description: todo.description,
      completed: todo.completed,
      created_at: todo.created_at.iso8601,
      updated_at: todo.updated_at.iso8601
    }
  end
end
