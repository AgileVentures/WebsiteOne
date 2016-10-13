require 'spec_helper'

describe UsersHelper do
  describe '#activity_tab' do
    context "with 'activity' parameter" do
      it "returns 'active'" do
        expect(helper.activity_tab('activity')).to eq('active')
      end
    end
    context "with parameter != 'activity'" do
      it 'returns nil' do
        expect(helper.activity_tab('other_param')).to be_nil
      end
    end
  end

  describe '#about_tab' do
    context "with 'activity' parameter" do
      it 'returns nil' do
        expect(helper.about_tab('activity')).to be_nil
      end
    end
    context "with parameter != 'activity'" do
      it "returns 'active'" do
        expect(helper.about_tab('other_param')).to eq('active')
      end
    end
  end
end
