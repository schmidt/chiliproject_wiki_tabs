module RedmineWikiTabs
  module Patches
    module WikiControllerPatch
      def self.included(base)
        base.class_eval do
          unloadable

          verify :method => :post, :only => :create, :render => {:nothing => true, :status => :method_not_allowed}

          include InstanceMethods
        end
      end

      module InstanceMethods
        def new
          @page = WikiPage.new(:wiki => @wiki)
          @page.content = WikiContent.new(:page => @page)

          @content = @page.content_for_version(nil)
          @content.text = initial_page_content(@page)
        end

        def new_child
          find_existing_page
          return if performed?

          old_page = @page

          new

          @page.parent_id = old_page.id
          render :action => 'new'
        end

        def create
          new

          @page.title     = params[:page][:title]
          @page.parent_id = params[:page][:parent_id]

          @content.attributes = params[:content]
          @content.author = User.current

          if @page.save
            attachments = Attachment.attach_files(@page, params[:attachments])
            render_attachment_warning_if_needed(@page)
            call_hook(:controller_wiki_edit_after_save, :params => params, :page => @page)
            redirect_to :action => 'show', :project_id => @project, :id => @page.title
          else
            render :action => 'new'
          end
        end
      end
    end
  end
end
