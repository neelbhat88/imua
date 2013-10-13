class UrlHelper
	def initialize()
	end

	def GetFullDefaultAvatarUrl(url)
		if url == "default-avatar.png"
			return "/assets/" + url
		end

		return url
	end

	def IsDefaultAvatarUrl(url)
		if url.include? "default-avatar.png"
			return true
		end

		return false
	end
end