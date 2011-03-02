require File.dirname(__FILE__) + '/../spec_helper'

describe WikiController do
  integrate_views

  before :each do
    @controller.stub!(:set_localization)

    @role = Factory.create(:non_member)
    @user = Factory.create(:admin)
    User.stub!(:current).and_return @user

    @project = Factory.create(:project)
    @project.reload # to get the wiki into the proxy
    
    @wiki_page = Factory.create(:wiki_page, :wiki_id => @project.wiki.id)
    content = Factory.create(:wiki_content, :page_id => @wiki_page.id, 
                                            :author_id => @user.id)
  end

  describe 'main menu links' do
    before do
      Factory.create(:wiki_tab, :wiki_id => @project.wiki.id)
      Factory.create(:wiki_tab, :wiki_id => @project.wiki.id)
      Factory.create(:wiki_tab, :wiki_id => @project.wiki.id)
    end

    describe 'default wiki tab' do
      it 'is active, when default start page is selected' do
        get 'show', :project_id => @project.id

        response.should be_success

        response.should have_tag('#main-menu') do
          with_tag 'a.wiki.selected'
        end
      end

      it 'is active, when an index page is shown' do
        get 'index', :project_id => @project.id

        response.should be_success

        response.should have_tag('#main-menu') do
          with_tag 'a.wiki.selected'
        end
      end

      it 'is inactive, when a custom wiki tab page is shown' do
        get 'show', :id => @project.wiki.tabs.first.title, :project_id => @project.id

        response.should be_success

        response.should have_tag('#main-menu') do
          with_tag 'a.wiki'
          without_tag 'a.wiki.selected'
        end
      end
    end

    describe 'custom wiki tab' do
      before do
        @wiki_tab = @project.wiki.tabs.first
      end

      it 'is inactive, when default start page is selected' do
        get 'show', :project_id => @project.id

        response.should be_success

        response.should have_tag('#main-menu') do
          with_tag "a.#{@wiki_tab.name.parameterize}"
          without_tag "a.#{@wiki_tab.name.parameterize}.selected"
        end
      end

      it 'is inactive, when other wiki start page is selected' do
        get 'show', :id => @project.wiki.tabs.last.title, :project_id => @project.id

        response.should be_success

        response.should have_tag('#main-menu') do
          with_tag "a.#{@wiki_tab.name.parameterize}"
          without_tag "a.#{@wiki_tab.name.parameterize}.selected"
        end
      end

      it 'is active, when the given custom wiki tab is shown' do
        get 'show', :id => @wiki_tab.title, :project_id => @project.id

        response.should be_success

        response.should have_tag('#main-menu') do
          with_tag "a.#{@wiki_tab.name.parameterize}.selected"
        end
      end
    end
  end

  describe 'wiki sidebar' do
    include ActionView::Helpers
    

    describe 'when show_default_tab is false' do
      before do
        @project.wiki.update_attribute(:show_default_tab, false)
      end

      it 'does not show the link to the wiki start page' do
        get 'show', :id => @wiki_page.title, :project_id => @project.id

        response.should be_success

        response.should have_tag '#sidebar' do
          without_tag "a[href=#{url_for(:action => 'show')}]"
        end
      end
    end

    describe 'when show_default_tab is true' do
      it 'does show the link to the wiki start page' do
        get 'show', :id => @wiki_page.title, :project_id => @project.id

        response.should be_success

        response.should have_tag '#sidebar' do
          with_tag "a[href=#{url_for(:action => 'show')}]"
        end
      end
    end
  end
end
