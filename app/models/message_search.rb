class MessageSearch
  include ActiveModel::Model

  attr_accessor :name

  def initialize(args = nil)
    return if args.nil?
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end
end