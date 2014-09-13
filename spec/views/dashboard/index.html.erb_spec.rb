require 'spec_helper'

describe 'dashboard/index.html.erb', type: :view do


  it 'displays statistics correctly' do
    let @stats[:articles][:count], 10
    @stats[:projects][:count] = 5
    @stats[:members][:count]  = 100
    @stats[:documents][:count] = 40
    #assign :stats, @stats
      render
      rendered.should contain('10 Articles Published')
      rendered.should contain('5 Active Projects')
      rendered.should contain('100 AgileVentures Members')
      rendered.should contain('40 Documents Created')
    end

end
