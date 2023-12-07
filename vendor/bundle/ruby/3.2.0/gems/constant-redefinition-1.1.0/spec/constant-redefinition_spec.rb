require 'spec_helper'

describe 'constant-redefinition' do
  describe 'class operations' do
    it 'can define a constant if not already defined' do
      Object.define_if_not_defined(:A, 1)

      1.should be(Object::A)
    end

    it 'can re-define a constant if already defined' do
      Object.define_if_not_defined(:B, 1)
      1.should be(Object::B)

      Object.redefine_without_warning(:B, 2)
      2.should be(Object::B)
    end

    it 'can set a constant if not already defined' do
      Object.redefine_without_warning(:C, 3)
      3.should be(Object::C)
    end

    it 'can set a constant and unset it if passed a block' do
      Object.define_if_not_defined(:GOOBLE, 'gobble') do
        Object.const_get(:GOOBLE).should == 'gobble'
      end

      lambda { Object.const_get(:GOOBLE) }.should raise_error(NameError)

      Object.redefine_without_warning(:GOOBLE, 'gobble') do
        Object.const_get(:GOOBLE).should == 'gobble'        
      end

      lambda { Object.const_get(:GOOBLE) }.should raise_error(NameError)
    end
  end

  describe 'module operations' do
    it 'can define a constant if not already defined' do
      Math.define_if_not_defined(:FOO, 2 * Math::PI)

      (2 * Math::PI).should == Math::FOO
    end

    it 'can re-define a constant if already defined' do
      Math.define_if_not_defined(:BAR, 3)
      3.should be(Math::BAR)

      Math.redefine_without_warning(:BAR, 5)
      5.should be(Math::BAR)
    end

    it 'can set a constant if not already defined' do
      Math.redefine_without_warning(:AMAZING, 3)
      3.should be(Math::AMAZING)
    end

    it 'can set a constant and unset it if passed a block' do
      Math.define_if_not_defined(:GOOBLE, 'gobble') do
        Math.const_get(:GOOBLE).should == 'gobble'
      end

      lambda { Math.const_get(:GOOBLE) }.should raise_error(NameError)

      Math.redefine_without_warning(:GOOBLE, 'gobble') do
        Math.const_get(:GOOBLE).should == 'gobble'        
      end

      lambda { Math.const_get(:GOOBLE) }.should raise_error(NameError)

      original_pi = Math::PI
      Math.redefine_without_warning(:PI, 6) do
        Math.const_get(:PI).should be(6)
      end
      Math.const_get(:PI).should == original_pi
    end
  end
end