module DateHelper
  def display_date(datetime)
    begin
      datetime.strftime("%m/%d/%Y")
    rescue
    end
  end

  def display_datetime(datetime)
    begin
      datetime.strftime("%m/%d/%Y %l:%M %p")
    rescue
      # display nothing
    end
  end
end  