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

  # Gets preference lists
	preferences = lines.last(length / 2).map do |p|
    p[3..p.length].split(' ').map(&:to_i)
  end 

  # Map people as Person objects
  people = lines.take(length / 2).each_with_index.map do |p, i|
    number, name = p.tr("\n", "").split(' ')
    person = Person.new(name, number.to_i, preferences[i])
  end

  people.each(&:display)

  # Remap every person's preference list to be an Person object reference
  people.each do |person|
    new_pref_list = person.preference_list.select{|pref| pref != 0 }.map{ |p| people.find{ |pref| pref.number == p}}
    person.preference_list = new_pref_list
  end
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

men = people.select{ |p| p.number.odd? }
women = people.select{ |p| p.number.even? }


men.each(&:display)
women.each(&:display)

match_couples(men, women)

men.each do |m|
  puts "#{m.name} -- #{m.engaged_to}"
end