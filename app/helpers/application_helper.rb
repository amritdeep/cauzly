module ApplicationHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, ("add_fields(this, '#{association}', '#{escape_javascript(fields)}')"))
  end
  
  
   def video_embed(url)
    render :partial => 'shared/embed_video', :locals => { :url => url }
   end
   
   def video_embed_thumb(url)
    render :partial => 'shared/embed_video_thumb', :locals => { :url => url }
   end 
   
   
   def get_avatar_small(user)
    if !user.user_logo.blank? && user.user_logo.attachment.exists?
      image_tag(user.user_logo.attachment.url(:small))
    else
      image_tag('no-img60.png')
    end
  end
  
  def get_avatar_thumb(user)
    if !user.user_logo.blank? && user.user_logo.attachment.exists?
      image_tag(user.user_logo.attachment.url(:thumb))
    else
      image_tag('no-img100.png')
    end
  end
  
  def get_avatar_original(user)
    if user.user_logo
     user.user_logo.attachment.url(:original)
    else
      'no-img100.png'
    end
  end
   
  def asset_fullpath(source)
"#{request.protocol}#{request.host}:#{request.port}#{asset_path(source)}"
end

  def attachment(source)
   "#{request.protocol}#{request.host}:#{request.port}#{source}"
  end
  
  
end
