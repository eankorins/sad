require 'open-uri'
require_relative 'needlewunsch'

Subject = Struct.new(:name, :sequence)
Test = Struct.new(:a, :b, :score, :a_seq, :b_seq)

def read_matrix 
	file = open('BLOSUM62.txt')
	lines = file.readlines.select { |l| not l.include?("#")}.map{|l|l.gsub("\n", '') }
	indices = lines.slice!(0).split(' ')
	index_list = lines.map do |l|
		key = l[0]
		values = l.scan(/([-+]?\d)/).flatten.map!(&:to_i)
		[key, values]
	end

	matrix_map = {}
	index_list.each do |key, values|
		temp = {}
		values.each.with_index do |val, i|
			temp[indices[i]] = val
		end
		matrix_map[key] = temp
	end
	matrix_map
end

def tests(file='Toy_FASTAs.out')
	file = open(file).readlines.join('')
	puts "#{file}"
	matches = file.scan(/(\w*-?\w*)--(\w*-?\w*): [+|-]?(\d*)\n(\w*)\n(.*)/)
	matches.map do |a,b,c,d,e|
		Test.new(a,b,c,d,e)
	end
end

def subjects(file='Toy_FASTAs.in')
	file = open(file).readlines.join('').split('>')
	matches = file.map {|x| x.split("\n")}
	matches.slice!(0)
	matches.map! do |x| 
		name = x.slice!(0).split(' ').slice(0)
		sequence = x.join('') 
		Subject.new(name, sequence)
	end
end

def run_tests(name)
	subjects = subjects(name + ".in")
	puts subjects
	tests = tests(name + ".out")
	puts tests
	sub_matrix = read_matrix
	puts sub_matrix
	tests.each do |test|
		a = subjects.find { |s| s.name == test.a}.sequence
		b = subjects.find { |s| s.name == test.b}.sequence
		needlewunsch = NeedleWunsch.new(a, b, sub_matrix, - 8)
		a_seq, b_seq, score = needlewunsch.best_alignment

		puts "#{a_seq == test.a_seq} #{b_seq == test.b_seq} #{score - test.score.to_i}"
	end
	
end

run_tests('Toy_FASTAs')

