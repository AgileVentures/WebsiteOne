# frozen_string_literal: true

describe LayoutHelper, type: :helper do
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

  describe '#flash_messages' do
    context 'without :layout_flash set' do
      let(:opts) { {} }
      before { flash_messages(opts) }

      it 'sets @layout_flash to true' do
        expect(@layout_flash).to be_truthy
      end
    end

    context 'with :layout_flash set' do
      let(:opts) { { layout_flash: false } }
      before { flash_messages(opts) }

      it 'sets @layout_flash opts(:layout_flash)' do
        expect(@layout_flash).to eq(opts[:layout_flash])
      end
    end

    context 'with or without :layout_flash set' do
      before { flash[:notice] = 'notice_flash' }
      let(:opts) { { layout_flash: false } }
      subject(:output) { flash_messages(opts) }

      it 'will have flash message' do
        expect(output).to include(flash[:notice])
      end
      it 'will have div with id for each flash' do
        expect(output).to have_selector('div#flash_notice')
      end
    end
  end
end
