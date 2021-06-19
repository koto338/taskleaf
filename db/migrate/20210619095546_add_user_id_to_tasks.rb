class AddUserIdToTasks < ActiveRecord::Migration[5.1]
  def up
    execute 'DELETE FROM tasks;'
    add_reference :tasks, :user, index: true
    change_column_null :tasks, :user_id, false
  end

  def down
    remove_column :tasks, :user, index: true
  end
end
