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
    
    # creating pages
    @page_with_content = Factory.create(:wiki_page, :wiki_id => @project.wiki.id,
                                                    :title   => 'Page with Content')
    @redirected_page = Factory.create(:wiki_page, :wiki_id => @project.wiki.id,
                                                  :title   => 'Target Title')
    @unrelated_page = Factory.create(:wiki_page, :wiki_id => @project.wiki.id,
                                                 :title   => 'Unrelated Page')

    # creating redirects
    @redirect = Factory.create(:wiki_redirect, :wiki_id      => @project.wiki.id,
                                               :title        => 'Source Title',
                                               :redirects_to => 'Target Title')

    # creating page contents
    Factory.create(:wiki_content, :page_id   => @page_with_content.id,
                                  :author_id => @user.id)
    Factory.create(:wiki_content, :page_id   => @redirected_page.id,
                                  :author_id => @user.id)
    Factory.create(:wiki_content, :page_id   => @unrelated_page.id,
                                  :author_id => @user.id)
  end

  describe '- main menu links' do
    before do
      @tab_for_page_with_content = Factory.create(:wiki_tab, :wiki_id => @project.wiki.id,
                                                             :name    => 'Tab for Page with Content',
                                                             :title   => @page_with_content.title)

      @tab_with_redirect = Factory.create(:wiki_tab, :wiki_id => @project.wiki.id,
                                                     :name    => 'Tab with Redirect',
                                                     :title   => @redirect.title)

      @tab_for_new_wiki_page = Factory.create(:wiki_tab, :wiki_id => @project.wiki.id,
                                                         :name    => 'Tab for new WikiPage',
                                                         :title   => 'New Wiki Page')
    end

    describe '- default wiki tab' do
      it 'is active, when default start page is selected' do
        get 'show', :project_id => @project.id

        response.should be_success
        response.should have_exactly_one_selected_tab_in(:project_menu)

        response.should have_tag('#main-menu') do
          with_tag 'a.wiki.selected'
        end
      end

      it 'is active, when an index page is shown' do
        get 'index', :project_id => @project.id

        response.should be_success
        response.should have_exactly_one_selected_tab_in(:project_menu)

        response.should have_tag('#main-menu') do
          with_tag 'a.wiki.selected'
        end
      end

      it 'is active, when a wiki page is shown, that does not match a custom wiki tab page' do
        get 'show', :id => @unrelated_page.title, :project_id => @project.id

        response.should be_success
        response.should have_exactly_one_selected_tab_in(:project_menu)

        response.should have_tag('#main-menu') do
          with_tag 'a.wiki.selected'
        end
      end

      it 'is inactive, when a custom wiki tab page is shown' do
        get 'show', :id => @tab_for_page_with_content.title, :project_id => @project.id

        response.should be_success
        response.should have_exactly_one_selected_tab_in(:project_menu)

        response.should have_tag('#main-menu') do
          with_tag 'a.wiki'
          without_tag 'a.wiki.selected'
        end
      end
    end

    shared_examples_for 'all custom wiki tabs' do
      it 'is inactive, when default start page is shown' do
        get 'show', :project_id => @project.id

        response.should be_success
        response.should have_exactly_one_selected_tab_in(:project_menu)

        response.should have_tag('#main-menu') do
          with_tag "a.#{@wiki_tab.name.parameterize}"
          without_tag "a.#{@wiki_tab.name.parameterize}.selected"
        end
      end

      it "is inactive, when an unrelated page is shown" do
        get 'show', :id => @unrelated_page.title, :project_id => @project.id

        response.should be_success
        response.should have_exactly_one_selected_tab_in(:project_menu)

        response.should have_tag('#main-menu') do
          with_tag "a.#{@wiki_tab.name.parameterize}"
          without_tag "a.#{@wiki_tab.name.parameterize}.selected"
        end
      end

      it "is inactive, when an other custom wiki tab's page is shown" do
        get 'show', :id => @other_wiki_tab.title, :project_id => @project.id

        response.should be_success
        response.should have_exactly_one_selected_tab_in(:project_menu)

        response.should have_tag('#main-menu') do
          with_tag "a.#{@wiki_tab.name.parameterize}"
          without_tag "a.#{@wiki_tab.name.parameterize}.selected"
        end
      end

      it 'is active, when the given custom wiki tab is shown' do
        get 'show', :id => @wiki_tab.title, :project_id => @project.id

        response.should be_success
        response.should have_exactly_one_selected_tab_in(:project_menu)

        response.should have_tag('#main-menu') do
          with_tag "a.#{@wiki_tab.name.parameterize}.selected"
        end
      end
    end

    describe '- custom wiki tab pointing to a redirect' do
      before do
        @wiki_tab = @tab_with_redirect
        @other_wiki_tab = @tab_for_new_wiki_page
      end

      it_should_behave_like 'all custom wiki tabs'
    end

    describe '- custom wiki tab pointing to a new wiki page' do
      before do
        @wiki_tab = @tab_for_new_wiki_page
        @other_wiki_tab = @tab_for_page_with_content
      end

      it_should_behave_like 'all custom wiki tabs'
    end

    describe '- custom wiki tab pointing to a saved wiki page' do
      before do
        @wiki_tab = @tab_for_page_with_content
        @other_wiki_tab = @tab_for_new_wiki_page
      end
      
      it_should_behave_like 'all custom wiki tabs'
    end
  end

  describe '- wiki sidebar' do
    include ActionView::Helpers

    describe 'when show_default_tab is false' do
      before do
        @project.wiki.update_attribute(:show_default_tab, false)
      end

      it 'does not show the link to the wiki start page' do
        get 'show', :id => @page_with_content.title, :project_id => @project.id

        response.should be_success

        response.should have_tag '#sidebar' do
          without_tag "a[href=#{url_for(:action => 'show')}]"
        end
      end
    end

    describe 'when show_default_tab is true' do
      before do
        @project.wiki.update_attribute(:show_default_tab, true)
      end

      it 'does show the link to the wiki start page' do
        get 'show', :id => @page_with_content.title, :project_id => @project.id

        response.should be_success

        response.should have_tag '#sidebar' do
          with_tag "a[href=#{url_for(:action => 'show')}]"
        end
      end
    end
  end
end
