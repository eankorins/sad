require 'open-uri'
require_relative 'person'

$debug = false

def read_file(name)
  # Reads file
	open(name).readlines.select { |line| line[0] != "#" }
end

def parse_data(file)

  raw_file = read_file(file)
  #Removes unwanted lines
  raw_file.slice!(raw_file.index("\n"))
  raw_file.slice!(0)
  length = raw_file.count

  #Returns array with person index and names
  raw_people = raw_file.take(length / 2)

  #preference list in 100 item chunks
  raw_preferences = raw_file.last(length / 2).each_slice(100)

	threads, preferences = [], []
  # Gets preference lists
  raw_preferences.each do |chunk|
    t = Thread.new(chunk) do |chunk|
      preferences << chunk.map do |p| 
        index = p[0..p.index(':') - 1].to_i
        preference_items = p[3..p.length].split(' ').map(&:to_i) - [0]
        { :index => index, :prefs => preference_items }
      end.flatten(1)
    end
    threads << t
  end 
  threads.each{|t|t.join}

  puts 'Creating people'

  preferences = preferences.flatten(1)
  #puts "#{preferences}"

  #Creates people objects for every person
  people = raw_people.each_with_index.map do |p, i|
    number, name = p.tr("\n", "").split(' ')
    preference_list = preferences.find{ |p| p[:index] == number.to_i}[:prefs]
    person = Person.new(name, number.to_i, preference_list)
  end
  #people.each(&:display)
  puts 'Remapping preferences'

  # Remap every person's preference list to be an Person object reference
  threads = []
    people.each_slice(100).each do |chunk|
      t = Thread.new {
        chunk.each do |person|
          new_pref_list = person.preference_list.map{ |p| people.find{ |pref| pref.number == p}}
          person.preference_list = new_pref_list
        end
      }
      threads << t
    end
  threads.each{|thr| thr.join}

  #Returns the list of all people
  people
end

def match_couples(men, women)
  #Breaks up all people
  men.each(&:break_up)
  women.each(&:break_up)

  #While there are single men (finds first single)
  while m = men.find(&:single?) do
    #It finds a woman in the preference list that he has not proposed to yet, and proposes
    w = m.preference_list.find { |w| not m.proposals.include?(w) }
    m.propose(w)
  end
end

def run(file)
  start = Time.now
  file_name = file[0..file.index('.') - 1]
  people = parse_data(file_name + ".in")
  puts "Running for #{file_name}"
  #Retrieves men
  men = people.select{ |p| p.number.odd? }
  #Retrieves women
  women = people.select{ |p| p.number.even? }
  men.each(&:display) if $debug
  women.each(&:display) if $debug
  #Matches
  match_couples(men, women)

  #Maps the resulting string for verification
  result_string = men.map do |m|
    "#{m.name} -- #{m.engaged_to}\n"
  end.join('') 

  #Loads file
  out = read_file(file_name + ".out").join('')
  # puts "#{out}"
  puts "#{result_string}" if $debug
  passed = (result_string == out) ? "Passed" : "Failed"
  duration = Time.now - start
  puts "Test #{passed} for #{file_name} and took #{duration} seconds "
end


$debug = ARGV[0] == "debug"

files = Dir.entries(File.dirname(__FILE__)).select do |f|
  f.include?(".in")
end

files.each do |f|
  run(f)
end
