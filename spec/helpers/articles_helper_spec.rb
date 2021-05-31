# frozen_string_literal: true

describe ArticlesHelper do
  context 'link_to_tags helper method' do
    it 'generates a hyperlink to the filtered articles index page' do
      tag = 'hello'
      output = helper.link_to_tags [tag]
      expect(output).to eq link_to(tag, articles_path(tag: tag))
    end

    it 'generates a comma separated link of tag links with multiple tags' do
      tags = %w(hello world)
      output = helper.link_to_tags tags
      expect(output).to eq "#{link_to(tags[0],
                                      articles_path(tag: tags[0]))}, #{link_to(tags[1], articles_path(tag: tags[1]))}"
    end
  end

  context 'rendering markdown' do
    it 'should correctly render markdown tags' do
      markdown_text = "#heading\nthis is some *markdown* text `with code` and **bold** text"
      output = helper.from_markdown markdown_text

      expect(output).to have_css 'h1'
      expect(output).to have_css 'em'
      expect(output).to have_css 'code'
      expect(output).to have_css 'strong'
    end

    it 'should render an empty string when the input is nil' do
      output = helper.from_markdown nil
      expect(output).to be_empty
    end

    it 'should render "Failed to render markdown" when it CodeRay fails for whatever reason' do
      renderer = ArticlesHelper::CodeRayify.new
      CodeRay.stub(:scan).and_raise Exception
      output = renderer.block_code 'function (a, b, c)', nil
      expect(output).to have_text 'Failed to render code block'
    end

    it 'should render block code correctly' do
      output = helper.from_markdown "this is an example:\n\n~~~ruby\nputs \"hello world\"\n~~~"

      expect(output).to_not have_text '~~~'
      expect(output).to_not have_text 'ruby'
      expect(output).to have_css '.code'
    end

    it 'should render block code without a language specified correctly' do
      output = helper.from_markdown "this is an example:\n\n~~~ruby\nplain text\n~~~"

      expect(output).to_not have_text '~~~'
      expect(output).to have_css '.code'
    end

    context 'preview' do
      it 'should render a truncated markdown text' do
        markdown_text = 'this is some `coding` done with **bold** text and some other random *stuff*' \
                        'a lot of random text or rather that goes on and on and on and on and on and on and on' \
                        "\n\n#heading\n until it reaches this heading"
        output = helper.markdown_preview markdown_text

        expect(output).to have_css 'code'
        expect(output).to have_css 'strong'
        expect(output).to_not have_css 'h1'
        expect(output).to_not have_css 'em'
      end

      it 'should not show links or image tags' do
        markdown_text = '`coding` can be really [fun](http://www.google.com) ![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 1")'
        output = helper.markdown_preview markdown_text

        expect(output).to have_css 'code'
        expect(output).to_not have_css 'a'
        expect(output).to_not have_css 'img'
      end

      it 'should render an empty string when the input is nil' do
        output = helper.markdown_preview nil
        expect(output).to be_empty
      end
    end
  end
end
