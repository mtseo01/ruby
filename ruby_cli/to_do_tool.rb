require 'json'
require 'date'
option = ARGV[0]

class ToDo
  DATA_FILE = './to_do_list.json'

  def initialize
    @date = Date.today
  end

  def view_list
    puts '< To-do List >'
    File.open(DATA_FILE, 'r') do |file|
      json = JSON.load(file)
      json['list'].each do |data|
        puts "| #{data['date']} | #{data['to-do'].center(30)} | #{data['state'].ljust(5)} |"
      end
    end
  end

  def create(to_do_name)
    @to_do_name = to_do_name
    json = File.open(DATA_FILE) { |f| JSON.load(f) }
    json['list'].push({ 'date' => "#{@date}", 'to-do' => "#{@to_do_name}", 'state' => 'Doing' })
    File.open(DATA_FILE, 'w') do |file|
      JSON.dump(json, file)
    end
  end

  def finish
    json = File.open(DATA_FILE) { |f| JSON.load(f) }
    json['list'].each.with_index(1) do |data, index|
      puts "#{index}. | #{data['date']} | #{data['to-do'].center(30)} | #{data['state'].ljust(5)} |"
    end
    print 'Select the number of list : '
    number = $stdin.gets.to_i
    json['list'][number - 1]['state'] = 'Done'
    to_do_name = json['list'][number - 1]['to-do']
    File.open(DATA_FILE, 'w') do |file|
      JSON.dump(json, file)
    end
    puts "#{to_do_name}, You did it!"
  end

  def remove
    json = File.open(DATA_FILE) { |f| JSON.load(f) }
    json['list'].each.with_index(1) do |data, index|
      puts "#{index}. | #{data['date']} | #{data['to-do'].center(30)} | #{data['state'].ljust(5)} |"
    end
    print 'Select the number of list (delete) : '
    number = $stdin.gets.to_i
    to_do_name = json['list'][number - 1]['to-do']
    puts "Delele, #{to_do_name}."
    json['list'].delete_at(number - 1)
    File.open(DATA_FILE, 'w') do |file|
      JSON.dump(json, file)
    end
  end

  def excute(option)
    case option
    when '-li', '--list'
      view_list
    when '-c', '--create'
      print 'Write the name of To-do : '
      to_do_name = $stdin.gets.chomp
      create(to_do_name)

    when '-f', '--finish'
      finish
    when '-rm', '--remove'
      remove
    else
      puts 'Unknown Command'
      puts 'Usage'
      puts 'ruby to_do_tool.rb [option]'
      puts 'option :'
      puts '  [-li] | [--list]   : View To-Do list'
      puts '  [-c]  | [--create] : Create To-Do'
      puts '  [-f]  | [--finish] : Change To-Do state to Done'
      puts '  [-rm] | [--remove] : Remove To-Do from list'
    end
  end
end

to_do = ToDo.new
to_do.excute(option)