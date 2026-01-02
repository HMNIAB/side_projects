#!/usr/bin/env/ruby

# frozen_string_literal: true

# VERSION: 0.0.0
# LAST UPDATED: 2025-12-31
# AUTHOR: HMNIAB

todo = []

def show_main_menu
  main_menu_options = ['[V]iew todos', '[N]ew todo', '[R]emove todo', '[Q]uit']
  main_menu_options.each { |option| puts option }
  print 'Selection: '
end

def show_todo_list(todo)
  system('clear')
  if todo.empty?
    puts 'Nothing to do here...'
  else
    puts 'TODO:'
    todo.each_with_index { |value, index| puts "[#{index}] #{value}" }
    puts
  end
end

def show_new_todo_menu(todo)
  print 'Enter new todo: '
  new_todo = gets.chomp.upcase
  todo.push(new_todo)
end

def remove_from_todo(todo)
  print 'Selection: '
  to_delete = gets.chomp.to_i
  todo.delete_at(to_delete)
end

def todo_file_write(todo)
  File.open('.tasks', 'w') do |file|
    todo.each { |task| file.write(task.upcase) }
  end
end

def todo_file_read(todo)
  return unless File.exist?('.tasks')

  tasks = File.readlines('.tasks', chomp: true)
  tasks.each do |task|
    todo.push(task)
  end
end

loop do
  show_main_menu
  menu_selection = gets.chomp.upcase
  case menu_selection
  when 'V'
    system('clear')
    todo_file_read(todo)
    show_todo_list(todo)
  when 'N'
    system('clear')
    show_new_todo_menu(todo)
  when 'R'
    system('clear')
    show_todo_list(todo)
    remove_from_todo(todo)
    system('clear')
  when 'Q'
    # this is a hack but it empties the file when the todo is empty....
    todo_file_write(todo)
    system('clear')
    exit
  end
end
