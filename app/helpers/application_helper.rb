module ApplicationHelper
  def env(key, default)
    return default unless ENV[key]
    val = ENV[key]
    return true if val == 'true'
    return false if val == 'false'
    return val.to_i if val.to_i.to_s == val
    val
  end

  def active_link_to(name = nil, options = nil, html_options = nil, &block)
    active_class = html_options[:active] || "active"
    html_options.delete(:active)
    html_options[:class] = "#{html_options[:class]} #{active_class}" if current_page?(options)
    link_to(name, options, html_options, &block)
  end

  def markdown(text)
    return '' if text.nil?

    options = {}
    extensions = {}
    renderer = Redcarpet::Render::HTML.new(options)
    @markdown ||= Redcarpet::Markdown.new(renderer, extensions)

    @markdown.render(text).html_safe
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to(name, "#", class: "link_to_remove_fields btn btn-danger")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to(name, "#", "data-association" => "#{association}",  "data-content" => "#{fields}", :class => "btn link_to_add_fields" )
  end
end
