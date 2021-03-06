module WikiTabs
  module Patches
    module ActiveRecordErrorsPatch
      def self.included(base)
        base.class_eval do
          def clear_with_wiki_tabs(*args)
            if args.empty?
              clear_without_wiki_tabs
            else
              args.each do |name|
                @errors.delete(name.to_s)
              end
              @errors
            end
          end

          alias_method_chain :clear, :wiki_tabs
        end
      end
    end
  end
end

unless ActiveRecord::Errors.included_modules.include?(WikiTabs::Patches::ActiveRecordErrorsPatch)
  ActiveRecord::Errors.send(:include, WikiTabs::Patches::ActiveRecordErrorsPatch)
end
