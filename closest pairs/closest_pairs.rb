class ClosestPairs
	attr_reader :points
	Point = Struct.new(:name, :x, :y)

	def initialize(points = [])
		@points = points.map{ |name, x, y| Point.new(name, x.to_f, y.to_f) }
	end

	def distance(p1, p2)
		Math.hypot(p1.x - p2.x, p1.y - p2.y)
	end

	def bruteforce(points = @points)
		mindist, min_point = Float::MAX, []
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
		
		xPoints = pts.sort_by(&:x)
		mid = (pts.length/2).ceil
		pLeft, pRight = xPoints[0, mid], xPoints[mid..-1]
		distLeft, pairLeft = closest(pLeft)
		distRight, pairRight = closest(pRight)
		dmin, dpair = distLeft < distRight ? [distLeft, pairLeft] : [distRight, pairRight]
		yPoints = xPoints.find_all { |p| (pLeft[-1].x - p.x).abs < dmin }.sort_by(&:y)
		closest = Float::MAX
		closestPair = []

		0.upto(yPoints.length - 2) do |i|
			(i+1).upto(yPoints.length - 1) do |k|
				break if (yPoints[k].y - yPoints[i].y) >= dmin
				dist = distance(yPoints[i], yPoints[k])
				closest, closestPair = dist, [yPoints[i], yPoints[k]] if dist < closest
			end
		end
		closest < dmin ? [closest, closestPair,@points.length] : [dmin, dpair, @points.length]
	end

end