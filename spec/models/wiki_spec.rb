require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Wiki do
  it 'has many tabs' do
    wiki = Factory.create(:wiki)
    test_tabs = [
      Factory.create(:wiki_tab, :wiki => wiki),
      Factory.create(:wiki_tab, :wiki => wiki),
      Factory.create(:wiki_tab_inactive, :wiki => wiki)
    ]

    wiki.tabs.should_not be_empty
    wiki.tabs.size.should == 3

    wiki.tabs.should be_all { |wiki_tab| test_tabs.include? wiki_tab }
  end

  it 'has many active tabs' do
    wiki = Factory.create(:wiki)
    test_tabs = [
      Factory.create(:wiki_tab, :wiki => wiki),
      Factory.create(:wiki_tab, :wiki => wiki),
      Factory.create(:wiki_tab_inactive, :wiki => wiki)
    ]

    wiki.tabs.active.should_not be_empty
    wiki.tabs.active.size.should == 2

    wiki.tabs.active.should be_all { |wiki_tab| wiki_tab.active? && test_tabs.include?(wiki_tab) }
  end

  describe 'validations' do
    before do
      @wiki = Factory.build(:wiki)
    end

    describe 'when show_default_tab is true' do
      before do
        @wiki.show_default_tab = true
      end

      it 'is valid with a start_page' do
        @wiki.start_page = 'Wiki'
        @wiki.should be_valid
      end

      it 'is invalid without a start_page' do
        @wiki.start_page = nil
        @wiki.should_not be_valid

        @wiki.start_page = ''
        @wiki.should_not be_valid
      end
    end

    describe 'when show_default_tab is false' do
      before do
        @wiki.show_default_tab = false
      end

      it 'is valid with a start_page' do
        @wiki.start_page = 'Wiki'
        @wiki.should be_valid
      end

      it 'is valid without a start_page' do
        @wiki.start_page = nil
        @wiki.should be_valid

        @wiki.start_page = ''
        @wiki.should be_valid
      end
    end
  end
end
