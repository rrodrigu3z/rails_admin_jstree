$ ->
  rails_admin_jstrees = $('.js_tree_nodes')
  rails_admin_jstree_url = rails_admin_jstrees.data('url') 
  
  rails_admin_jstrees.jstree(
    themes:
      theme: "apple"
      dots: false,
      icons: true
    
    plugins: ["themes", "json_data", "ui", "crrm", "cookies", "dnd", "search", "types", "hotkeys"]
    json_data:
      ajax:
        url: rails_admin_jstree_url
        data: (n) ->
          operation: "get_children"
          id: (if n.attr then n.attr("id") else 'root')
  ).bind("create.jstree", (e, data) ->
    $.post(rails_admin_jstree_url, 
      operation: "create_node"
      id: if data.rslt.parent.attr then data.rslt.parent.attr("id") else 'root'
      position: data.rslt.position
      name: data.rslt.name 
    , (r) ->
      if r.status
        $(data.rslt.obj).attr "id", r.id
      else
        $.jstree.rollback data.rlbk
    )
  ).bind("remove.jstree", (e, data) ->
    data.rslt.obj.each ->
      $.ajax
        async: false
        type: "POST"
        url: rails_admin_jstree_url
        data:
          operation: "remove_node"
          id: @id
        success: (r) ->
          data.inst.refresh() unless r.status
  ).bind("rename.jstree", (e, data) ->
    $.post(rails_admin_jstree_url,
      operation: "rename_node"
      id: data.rslt.obj.attr("id")
      name: data.rslt.new_name
    , (r) ->
      $.jstree.rollback data.rlbk unless r.status
    )
  ).bind("move_node.jstree", (e, data) ->
    data.rslt.o.each (i) ->
      $.ajax
        async: false
        type: "POST"
        url: rails_admin_jstree_url
        data:
          operation: "move_node"
          id: $(this).attr("id")
          parent_id: (if data.rslt.cr is -1 then 'root' else data.rslt.np.attr("id"))
          position: data.rslt.cp + i
          copy: (if data.rslt.cy then true else false)

        success: (r) ->
          unless r.status
            $.jstree.rollback data.rlbk
          else
            $(data.rslt.oc).attr "id", r.id
            data.inst.refresh data.inst._get_parent(data.rslt.oc)  if data.rslt.cy and $(data.rslt.oc).children("UL").length
            # $("#analyze").click()
  ).bind("select_node.jstree", (event, data) ->
    $('#edit').attr('href', rails_admin_jstree_url.replace('jstree', "#{data.rslt.obj.attr("id")}/edit"))
    
    $.ajax
      async: false
      url: rails_admin_jstree_url
      data:
        operation: "show_node"
        id: data.rslt.obj.attr("id")
  )

  $("#jstree_menu a").click ->
    switch @id
      when "create"
        rails_admin_jstrees.jstree "create", null, "last"
      when "edit"
        console.log "TODO: redirect to EDIT!!!"
      else
        rails_admin_jstrees.jstree @id
  