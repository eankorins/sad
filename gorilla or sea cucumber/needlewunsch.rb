class NeedleWunsch
	attr_accessor :a, :b, :min, :gap_penalty, :sub_matrix, :score_matrix, :traceback_matrix

	def initialize(a,b,sub_matrix, gap_penalty)
		@a = a.split('')
		@b = b.split('')

		@sub_matrix = sub_matrix
		@gap_penalty = gap_penalty
		init_matrix
	end

	def fill_matrix

		traverse_matrix do |i, j|
			if i == 0 && j == 0
				@score_matrix[i][j] = 0
			elsif i==0
				@score_matrix[0][j] = j * @gap_penalty
			elsif j==0
				@score_matrix[i][0] = i * @gap_penalty
			else
				up = @score_matrix[i-1][j].to_i + @gap_penalty
				left = @score_matrix[i][j-1].to_i + gap_penalty
				diagonal = @score_matrix[i-1][j-1].to_i + score(@a[i-1], @b[j-1])

				max, dir = diagonal, "D"
				max, dir = up, "U" if up > max
				max, dir = left, "L" if left > max
				@score_matrix[i][j] = max
				@traceback_matrix[i][j] = dir
			end
		end
	end
	def best_alignment
		init_matrix
		fill_matrix

		i = @score_matrix.length - 1
		j = @score_matrix[0].length - 1
		a = []
		b = []
		dir = @traceback_matrix[i][j]
		while dir  != 'F'
			if dir == "D"
				a.push @a[i-1]
				b.push @b[j-1]
				i -= 1
				j -= 1
			elsif dir == "L"
				a.push "-"
				b.push @b[j-1]
				j -= 1
			elsif 
				a.push @a[i-1]
				b.push "-"
				i -= 1
			end
			dir = @traceback_matrix[i][j] 
		end
		score = a.zip(b).inject(0) { |total, (a,b)| total += score(a,b)}


		[a.join.upcase.reverse,b.join.upcase.reverse,score]
	end

	def init_matrix
		@score_matrix = Array.new(@a.length + 1)
		@traceback_matrix = Array.new(@a.length + 1)
		
		@score_matrix.each_index do |i| 
			@score_matrix[i]   = Array.new(@b.length+1)
			@traceback_matrix[i] = Array.new(@b.length+1)
			@traceback_matrix[0].each_index { |j| @traceback_matrix[0][j] = "L" if j != 0}
		end

		@traceback_matrix.each_index { |k| @traceback_matrix[k][0] = "U" if k != 0 }
		@traceback_matrix[0][0] = "F"
	end

	def score(a,b)
		@sub_matrix[a][b]
	end

	def print_table(the_matrix = @score_matrix)
        puts
        puts "a=" + @a.to_s
        puts "b=" + @b.to_s
        puts
        print "   "

        @b.each_index {|elem| print " " + @b[elem].to_s }

        puts ""
        traverse_matrix do |i, j|
            if j==0 and i > 0
                print @a[i-1]
            elsif j==0
                print " "
            end
            print " " + the_matrix[i][j].to_s

            puts "" if j==the_matrix[i].length-1
        end
    end

	def traverse_matrix
		@score_matrix.each_index do |i|
			@score_matrix[i].each_index do |j|
				yield(i,j)
			end
		end
	end
end
