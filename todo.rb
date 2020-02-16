require "active_record"
require "./connect_db"



class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def over_due?
    due_date < Date.today
  end

  def due_later?
    due_date > Date.today
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    puts "#{self.id}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.overdue
    where("due_date < ?", Date.today)
  end

  def self.duetoday
    where("due_date = ?", Date.today)
  end

  def self.duelater
    where("due_date > ?", Date.today)
  end


  def self.show_list
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    puts overdue.order(due_date: :asc).map { |todo| todo.to_displayable_string }
    puts "\n"

    puts "Due Today\n"
    puts duetoday.order(due_date: :asc).map { |todo| todo.to_displayable_string }
    puts "\n"

    puts "Due Later\n"
    puts duelater.order(due_date: :asc).map { |todo| todo.to_displayable_string }
    puts "\n"
  end

  def self.add_task(h)
    todo = Todo.create(todo_text: h[:todo_text], due_date: Date.today + h[:due_in_days], completed: false)
    return todo
  end

  def self.mark_as_complete!(todo_id)
    todo = Todo.find(todo_id)
    todo.update(completed: true)
    return todo
  end
end
