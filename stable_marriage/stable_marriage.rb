require 'open-uri'
require_relative 'person'

def directory_files(dir)
end

def read_file(name)
  # Reads file
	lines = open(name).readlines.select { |line| line[0] != "#" }
	lines.slice!(lines.index("\n"))
  lines.slice!(0)
	length = lines.count
  puts 'Reading preferences'
  # Gets preference lists
  chunks = lines.last(length / 2).each_slice(100)
	threads = []
  preferences = []
  chunks.each do |chunk|
    t = Thread.new { preferences << chunk.map do |p|
    p[3..p.length].split(' ').map(&:to_i)
    end }
    threads << t
    puts threads.count
    if threads.count == 20
      threads.each { |thr| thr.join}
      threads = []
    end
  end 

  threads.each{|t|t.join}
  threads = []
  prefs = []
  preferences.each do |pref|
    pref.each do |item|
      prefs << item
    end
  end
  puts "#{prefs}"
  puts 'Creating people'
  # Map people as Person objects
  p_index = 0
  people = lines.take(length / 2).each_with_index.map do |p, i|
    number, name = p.tr("\n", "").split(' ')
    person = Person.new(name, number.to_i, prefs[i])
  end
  people.each(&:display)
  puts 'Remapping preferences'
  # Remap every person's preference list to be an Person object reference
  peoples = people.each_slice(100)
  peoples.each do |people|
    t = Thread.new { people.each do |person|
      new_pref_list = person.preference_list.select{|pref| pref != 0 }.map{ |p| peoples.find{ |pref| pref.number == p}}
      person.preference_list = new_pref_list end }
      threads << t
      if threads.count == 20
        threads.each { |thr| thr.join}
        threads = []
      end
  end
  threads.each{|t|t.join}
end

def match_couples(men, women)
  men.each(&:break_up)
  women.each(&:break_up)
  while m = men.find(&:single?) do
    w = m.preference_list.find { |w| not m.proposals.include?(w) }
    m.propose(w)
  end
end
puts File.dirname(__FILE__)
directory_files(ARGV[0])

people = read_file(ARGV[0])
puts 'Getting men'
men = people.select{ |p| p.number.odd? }
puts 'Getting women'
women = people.select{ |p| p.number.even? }


# men.each(&:display)
# women.each(&:display)
'Matching'
match_couples(men, women)

men.each do |m|
  puts "#{m.name} -- #{m.engaged_to}"
end