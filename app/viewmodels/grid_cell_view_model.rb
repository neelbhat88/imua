class GridCellViewModel
	attr_accessor :isempty, :rownum, :value, :cellnum, :semester, :isminreq

	def initialize(rownum, cellnum, semester)
		@isempty = true
		@rownum = rownum
		@colnum = semester - 1
		@value = GetValue(rownum)
		@cellnum = cellnum
		@semester = semester
		@isminreq = false #IsMinReq(semester, rownum)
	end

	# Grid setup
	# (0,0) (0,1) (0,2)
	# (1,0) (1,1) (1,2)
	# (2,0) (2,1) (2,2)

	def GetValue(rownum)
		valueArray = [50, 40, 30, 20, 10]

		return valueArray[rownum]
	end

	def IsMinReq(sem, row)
		if row > 1
			return true
		end

		return false
	end
end