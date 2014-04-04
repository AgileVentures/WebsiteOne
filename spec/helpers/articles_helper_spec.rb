require 'spec_helper'

describe ArticlesHelper do

  context 'link_to_tags helper method' do

    it 'generates a hyperlink to the filtered articles index page' do
      tag = 'hello'
      output = helper.link_to_tags [ tag ]
      output.should eq link_to(tag, articles_path(tag: tag))
    end

    it 'generates a comma separated link of tag links with multiple tags' do
      tags = %w( hello world )
      output = helper.link_to_tags tags
      output.should eq "#{link_to(tags[0], articles_path(tag: tags[0]))}, #{link_to(tags[1], articles_path(tag: tags[1]))}"
    end
  end

  context 'rendering markdown' do

    it 'should correctly render markdown tags' do
      markdown_text = "#heading\nthis is some *markdown* text `with code` and **bold** text"
      output = helper.from_markdown markdown_text

      output.should have_css 'h1'
      output.should have_css 'em'
      output.should have_css 'code'
      output.should have_css 'strong'
    end

    it 'should render an empty string when the input is nil' do
      output = helper.from_markdown nil
      output.should be_empty
    end

    it 'should render "Failed to render markdown" when it CodeRay fails for whatever reason' do
      renderer = ArticlesHelper::CodeRayify.new
      CodeRay.stub(:scan).and_raise Exception
      output = renderer.block_code 'function (a, b, c)', nil
      output.should have_text 'Failed to render code block'
    end

    it 'should render block code correctly' do
      output = helper.from_markdown "this is an example:\n\n~~~ruby\nputs \"hello world\"\n~~~"

      output.should_not have_text '~~~'
      output.should_not have_text 'ruby'
      output.should have_css '.code'
    end

    it 'should render block code without a language specified correctly' do
      output = helper.from_markdown "this is an example:\n\n~~~ruby\nplain text\n~~~"

      output.should_not have_text '~~~'
      output.should have_css '.code'
    end

    context 'preview' do
      it 'should render a truncated markdown text' do
        markdown_text = 'this is some `coding` done with **bold** text and some other random *stuff*' +
            'a lot of random text or rather that goes on and on and on and on and on and on and on' +
            "\n\n#heading\n until it reaches this heading"
        output = helper.markdown_preview markdown_text

        output.should have_css 'code'
        output.should have_css 'strong'
        output.should_not have_css 'h1'
        output.should_not have_css 'em'
      end

      it 'should not show links or image tags' do
        markdown_text = '`coding` can be really [fun](http://www.google.com) ![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 1")'
        output = helper.markdown_preview markdown_text

        output.should have_css 'code'
        output.should_not have_css 'a'
        output.should_not have_css 'img'
      end

      it 'should render an empty string when the input is nil' do
        output = helper.markdown_preview nil
        output.should be_empty
      end
    end
  end
end
