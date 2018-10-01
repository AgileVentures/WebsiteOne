<<<<<<< HEAD
module StaticPagesHelper
	
	def github_static_pages_edit_url
		"https://github.com/AgileVentures/AgileVentures/edit/master/#{@page.title.tr(' ','_').upcase}.md"
	end
=======
module StaticPagesHelper	
  def github_static_pages_edit_url
    "https://github.com/AgileVentures/AgileVentures/edit/master/#{@page.title.tr(' ','_').upcase}.md"
  end
>>>>>>> 8be2f0dd9b5f58dfb4cf3e87a07ab26138ccca29
end