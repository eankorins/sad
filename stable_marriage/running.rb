
def factorial(n, current)
	start = Time.now
	for i in 0..n
		current = current + 1
	end
	n = n + 1
	puts "#{Time.now - start}"
	if n == 0
		factorial(n - 1, current)
	else 
		current
	end
end
s = 1
100.times {
	result = factorial(s, 0)
	s = s * 2
}

