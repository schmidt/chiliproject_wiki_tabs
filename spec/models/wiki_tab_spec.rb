#-- encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WikiTab do
  describe '#tab_class' do
    it 'generates a valid css/html class name based on the wiki tab\'s name' do
      WikiTab.new(:name => 'Käse kuchen').tab_class.should.to_s == 'kase-kuchen'
    end

    it 'generates non-empty strings for tabs without [A-z0-9-_]' do
      WikiTab.new(:name => '?!??!').tab_class.should_not be_empty
    end
  end
end
