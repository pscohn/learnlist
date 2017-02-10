module ApplicationHelper
  def markdown(text)
    options = {}
    extensions = {}
    renderer = Redcarpet::Render::HTML.new(options)
    @markdown ||= Redcarpet::Markdown.new(renderer, extensions)

    @markdown.render(text).html_safe
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to(name, "#", class: "link_to_remove_fields")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to(name, "#", "data-association" => "#{association}",  "data-content" => "#{fields}", :class => "link_to_add_fields" )
  end
end
