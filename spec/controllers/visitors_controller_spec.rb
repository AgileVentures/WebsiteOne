# frozen_string_literal: true

describe VisitorsController do
  let(:valid_params) { { name: 'Ivan', email: 'my@email.com', message: 'Love your site!' } }
  it 'renders index template' do
    get :index
    expect(response).to render_template('index')
  end

  it 'assigns event to next_occurrence' do
    event = double(Event)
    expect(Event).to receive(:next_occurrence).with(:Scrum).and_return(event)
    get :index
    expect(assigns(:event)).to eq event
  end
end
