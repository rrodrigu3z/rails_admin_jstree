module RailsAdminJstree
  class Engine < ::Rails::Engine
    
    initializer "RailsAdminNestable precompile hook" do |app|
      app.config.assets.precompile += %w(
        rails_admin/rails_admin_jstree.js 
        rails_admin/jstree/jquery.jstree.js 
        rails_admin/jstree/jquery.cookie.js 
        rails_admin/jstree/jquery.hotkeys.js 
        rails_admin/jstree/theme/apple/style.css 
        rails_admin/jstree/theme/classic/style.css
        rails_admin/jstree/theme/default/style.css
        rails_admin/jstree/theme/default-rtl/style.css
      )
    end
    
  end
end
