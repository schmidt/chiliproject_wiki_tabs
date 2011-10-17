class WikiTab < ActiveRecord::Base
  belongs_to :wiki
  named_scope :active, :conditions => {:active => true}

  validates_presence_of :title
  validates_format_of :title, :with => /^[^,\.\/\?\;\|\:]*$/

  validates_presence_of :name

  def tab_class
    @tab_class ||= begin
      tab_class = self.name.parameterize
      tab_class = "wiki-#{self.id}" if tab_class.blank?
      tab_class
    end
  end
end
