require File.dirname(__FILE__) + '/../spec_helper'

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
end
