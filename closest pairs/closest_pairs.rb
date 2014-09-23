class ClosestPairs
	attr_reader :points, :yPointCounter
	Point = Struct.new(:name, :x, :y)

	def initialize(points = [])
		@points = points.map{ |name, x, y| Point.new(name, x.to_f, y.to_f) }
		@yPointCounter = 0
	end

	def distance(p1, p2)
		Math.hypot(p1.x - p2.x, p1.y - p2.y)
	end

	def bruteforce(points = @points)
		mindist, min_point = Float::MAX, []
		#Pairs every point, and returns the closest
		points.length.times do |i|
			(i+1).upto(points.length-1) do |j|
				dist = distance(points[i], points[j])
				mindist, min_point = dist, [points[i], points[j]] if dist < mindist
			end
		end
		return [mindist, min_point]
	end

	def closest(pts = @points)
		if pts.length <= 3
			return bruteforce(pts)
		end
		#Sorts by the x point ascending order
		xPoints = pts.sort_by(&:x)
		mid = (pts.length/2).ceil
		pLeft, pRight = xPoints[0, mid], xPoints[mid..-1]
		distLeft, pairLeft = closest(pLeft)
		distRight, pairRight = closest(pRight)

		#Checks whether the right or left side has the closest pair
		dmin, dpair = distLeft < distRight ? [distLeft, pairLeft] : [distRight, pairRight]

		# Takes all the points that have shorter x distance than the current min distance
		# and sorts by y in ascending order
		yPoints = xPoints.find_all { |p| (pLeft[-1].y - p.y).abs < dmin }.sort_by(&:y)
		closest = Float::MAX
		closestPair = []

		#Pairs every remaining points
		0.upto(yPoints.length) do |i|
			(i+1).upto(yPoints.length - 1) do |k|
				# Breaks for pair if its y distance is longer than current min distance
				dist = distance(yPoints[i], yPoints[k])
				# Takes new closest distance and pair if distance is shorter than current closest
				closest, closestPair = dist, [yPoints[i], yPoints[k]] if dist < closest
			end
		end
		closest < dmin ? [closest, closestPair,@points.length] : [dmin, dpair, @points.length]
	end

end