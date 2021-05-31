# frozen_string_literal: true

shared_examples 'presentable' do
  subject { described_class.new }

  it 'should have a presenter' do
    expect { subject.presenter }.to_not raise_error
  end
end
