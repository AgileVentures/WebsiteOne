<<<<<<< HEAD
module StaticPagesHelper
	
	def github_static_pages_edit_url
		"https://github.com/AgileVentures/AgileVentures/edit/master/#{@page.title.tr(' ','_').upcase}.md"
	end
end
=======
module StaticPagesHelper	
  def github_static_pages_edit_url
    "https://github.com/AgileVentures/AgileVentures/edit/master/#{@page.title.tr(' ','_').upcase}.md"
  end
end
>>>>>>> 4034e73f3c13ada46eaa385ea622a2d48fb161d3
