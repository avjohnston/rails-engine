class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.page_helper(page = 1, per_page = 20)
    page = 1 if page < 1
    per_page = 20 if per_page < 1

    offset = ((page - 1) * per_page)
    self.offset(offset).limit(per_page)
  end
end
