require 'spec_helper'

describe LayoutHelper, :type => :helper do

  describe '#show_layout_flash?' do
    subject { show_layout_flash? }

    context 'without a layout flash' do
		  before { @layout_flash = nil }
      it { is_expected.to be_truthy }
    end
    
    context 'with a layout flash' do
      before { @layout_flash = 'layout flash' }
      it { is_expected.to be_truthy }
    end
  end

# Not complete, need to rethink this whole portion
  describe '#flash_messages' do

    context 'without :layout_flash set' do
      let(:opts){ Hash.new }
      before { flash_messages(opts) }

      it 'sets @layout_flash to true' do
        expect(@layout_flash).to be_truthy
      end
    end

    context 'with :layout_flash set' do
      let(:opts){ {:layout_flash => false} }
      before { flash_messages(opts) }

      it 'sets @layout_flash opts(:layout_flash)' do
        expect(@layout_flash).to eq(opts[:layout_flash])
      end
    end
  end
end
