class RedmineJournals


  def initialize(journal)

    #TODO
    #si no es un array algo va mal y mejor devolvemos nill

    # si tenemos comentarios los satinizamos
    if journal['notes']
      journal['notes'] = markdown2html(journal['notes'])
    end

    # journal['details'].each do |action|


    #   case action['name']

    #     when 'status_id'

    #     when 'assigned_to_id'

    #     when 'due_date'

    #     when 'fixed_version_id'
          
    #     when 'done_ratio'

    #   end    

    #   # puts action['name']


    # end

    # binding.pry
    # puts journal
    
    return journal
  end


  def markdown2html(text)

    options = {
        filter_html:     true,
        hard_wrap:       true, 
        link_attributes: { rel: 'nofollow', target: "_blank" },
        space_after_headers: true, 
        fenced_code_blocks: true
      }

      extensions = {
        autolink:           true,
        superscript:        true,
        disable_indented_code_blocks: true
      }

      renderer = Redcarpet::Render::HTML.new(options)
      markdown = Redcarpet::Markdown.new(renderer, extensions)

      return markdown.render(text)

    return markdown
  end

  def  status_id (value) 
  end 

  def assigned_to_id (value)
  end

  def due_date (value)
  end

  def fixed_version_id (value)
  end

  def done_ratio (value)
  end

end
