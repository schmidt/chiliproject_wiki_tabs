require File.dirname(__FILE__) + '/../spec_helper'

describe WikisController do
  before :each do
    @controller.stub!(:set_localization)

    @role = Factory.create(:non_member)
    @user = Factory.create(:admin)
    User.stub!(:current).and_return @user
    
    @params = {
      :wiki => {
        :tabs_attributes => { 
          :'0' => {:name => "abc", :title => "def", :_destroy => "", :active => "1"}
        }, 
        :start_page => "Start Page"
      }
    }
  end

  describe 'post to edit' do
    it 'still sets the wiki home page' do
      project = Factory.create(:project)
      project.reload

      post 'edit', @params.merge(:id => project.identifier)

      project.reload

      project.wiki.should_not be_nil
      project.wiki.start_page.should == 'Start Page'
    end

    it 'creates new wiki_tabs' do
      project = Factory.create(:project)
      project.reload
      wiki = project.wiki

      post 'edit', @params.merge(:id => project.identifier)

      wiki.reload

      wiki.tabs.should_not be_empty
      wiki.tabs.size.should == 1

      wiki_tab = wiki.tabs.first
      wiki_tab.name.should == 'abc'
      wiki_tab.title.should == 'def'
      wiki_tab.should be_active
    end

    it 'ignores creation of empty tabs' do
      project = Factory.create(:project)
      project.reload
      wiki = project.wiki

      @params[:wiki][:tabs_attributes][:'1'] = {
        :name => '', :title => ''
      }

      post 'edit', @params.merge(:id => project.identifier)

      project.reload
      wiki = project.wiki

      wiki.tabs.should_not be_empty
      wiki.tabs.size.should == 1
    end

    it 'updates existing wiki tabs' do
      project = Factory.create(:project)
      project.reload
      wiki = project.wiki

      tab = Factory.create(:wiki_tab, :wiki_id => wiki.id, :name => 'Name', :title => 'Title', :active => false)

      @params[:wiki][:tabs_attributes][:'0'][:id] = tab.id

      post 'edit', @params.merge(:id => project.identifier)

      project.reload
      wiki = project.wiki

      tab.reload

      wiki.tabs.should_not be_empty
      wiki.tabs.size.should == 1

      tab.name.should == 'abc'
      tab.title.should == 'def'
      tab.should be_active
    end

    it 'deletes existing wiki tabs' do
      project = Factory.create(:project)
      project.reload
      wiki = project.wiki
      tab = Factory.create(:wiki_tab, :wiki_id => wiki.id, :name => 'Name', :title => 'Title', :active => false)

      @params[:wiki][:tabs_attributes][:'0'][:id] = tab.id
      @params[:wiki][:tabs_attributes][:'0'][:_destroy] = '1'

      post 'edit', @params.merge(:id => project.identifier)

      project.reload
      project.wiki.tabs.should be_empty
      WikiTab.find(:all).should be_empty
    end
  end

  describe 'post to destroy' do
    it 'still destroys the wiki' do
      project = Factory.create(:project)
      project.reload
      wiki = project.wiki

      project.wiki.should_not be_nil # since it was create automatically

      post :destroy, :id => project.identifier, :confirm => 1

      project.reload

      project.wiki.should be_nil
    end

    it "destroys all the project's wiki tabs" do
      project = Factory.create(:project)
      project.reload
      wiki = project.wiki

      Factory.create(:wiki_tab, :wiki_id => wiki.id)
      Factory.create(:wiki_tab, :wiki_id => wiki.id)

      post :destroy, :id => project.identifier, :confirm => 1

      WikiTab.find(:all).should be_empty
    end
  end
end
