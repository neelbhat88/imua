class GridCellViewModel
	attr_accessor :isempty, :rownum, :value, :cellnum, :semester, :isminreq

	def initialize(rownum, cellnum, semester)
		@isempty = true
		@rownum = rownum
		@colnum = semester - 1
		@value = GetValue(rownum)
		@cellnum = cellnum
		@semester = semester
		@isminreq = IsMinReq(semester, rownum)
	end

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