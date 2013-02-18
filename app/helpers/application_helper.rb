module ApplicationHelper
  def parse_date(hash, field_name)
    Date.new(
      hash["#{field_name.to_s}(1i)"].to_i,
      hash["#{field_name.to_s}(2i)"].to_i,
      hash["#{field_name.to_s}(3i)"].to_i
    )
  end
end
