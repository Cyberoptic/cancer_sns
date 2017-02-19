class PaginatingDecorator < Draper::CollectionDecorator
	delegate :current_page, :total_pages, :limit_value, :total_count,
     :entry_name, :offset_value, :last_page?, :total_entries, :next_page

  def entry_name
    object.class.name
  end
end
