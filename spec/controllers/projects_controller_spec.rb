require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProjectsController do
  before :each do
    @controller.stub!(:set_localization)

    @role = Factory.create(:non_member)
    @user = Factory.create(:admin)
    User.stub!(:current).and_return @user

    @params = {}
  end

  describe 'show' do
    integrate_views

    describe 'without wiki' do
      before do
        @project = Factory.create(:project)
        @project.reload # project contains wiki by default
        @project.wiki.destroy
        @project.reload
        @params[:id] = @project.id
      end

      it 'renders show' do
        get 'show', @params
        response.should be_success
        response.should render_template 'show'
      end

      it 'renders main menu without wiki tab' do
        get 'show', @params

        response.should have_tag('#main-menu') do
          without_tag 'a.wiki'
        end
      end
    end

    describe 'with wiki' do
      before do
        @project = Factory.create(:project)
        @project.reload # project contains wiki by default
        @params[:id] = @project.id
      end

      describe 'without custom wiki tabs' do
        it 'renders show' do
          get 'show', @params
          response.should be_success
          response.should render_template 'show'
        end

        it 'renders main menu with wiki tab' do
          get 'show', @params

          response.should have_tag('#main-menu') do
            with_tag 'a.wiki', :content => 'Wiki'
          end
        end

        describe 'with show_default_tab disabled' do
          it 'renders main menu without wiki tab' do
            @project.wiki.update_attribute(:show_default_tab, false)
            get 'show', @params

            response.should have_tag('#main-menu') do
              without_tag 'a.wiki', :content => 'Wiki'
            end
          end
        end
      end

      describe 'with custom wiki tabs' do
        before do
          Factory.create(:wiki_tab, :wiki_id => @project.wiki.id, :name => 'Active', :title => 'Active Wiki', :active => true)
          Factory.create(:wiki_tab, :wiki_id => @project.wiki.id, :name => 'Inactive', :title => 'Inactive Wiki', :active => false)
        end

        it 'renders show' do
          get 'show', @params
          response.should be_success
          response.should render_template 'show'
        end

        it 'renders main menu with wiki tab' do
          get 'show', @params

          response.should have_tag('#main-menu') do
            with_tag 'a.wiki', :content => 'Wiki'
          end
        end

        it 'renders main menu with custom active wiki tab' do
          get 'show', @params

          response.should have_tag('#main-menu') do
            with_tag 'a.active', :content => 'Active'
          end
        end

        it 'renders main menu without custom in-active wiki tab' do
          get 'show', @params

          response.should have_tag('#main-menu') do
            without_tag 'a.inactive'
          end
        end

        describe 'with show_default_tab disabled' do
          it 'renders main menu without wiki tab' do
            @project.wiki.update_attribute(:show_default_tab, false)
            get 'show', @params

            response.should have_tag('#main-menu') do
              without_tag 'a.wiki', :content => 'Wiki'
            end
          end
        end
      end
    end
  end
end
