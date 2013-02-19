module ApplicationHelper
  def parse_date(hash, field_name)
    Date.new(
      hash["#{field_name.to_s}(1i)"].to_i,
      hash["#{field_name.to_s}(2i)"].to_i,
      hash["#{field_name.to_s}(3i)"].to_i
    )
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |b|
      render "#{association.to_s.singularize}_fields", f: b
    end
    link_to(name, '#', class: 'add_fields', 
      data: {id: id, fields: fields.gsub('\n', '')})
  end
end
