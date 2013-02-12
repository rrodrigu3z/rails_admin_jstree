module RailsAdminJstree
  class Engine < ::Rails::Engine
    
    initializer "RailsAdminNestable precompile hook" do |app|
      app.config.assets.precompile += %w(
        rails_admin/rails_admin_jstree.js 
        rails_admin/jquery.jstree.js 
        rails_admin/jquery.cookie.js 
        rails_admin/jquery.hotkeys.js 
        rails_admin_jstree/theme/apple/style.css 
        rails_admin_jstree/theme/classic/style.css
        rails_admin_jstree/theme/default/style.css
        rails_admin_jstree/theme/default-rtl/style.css
      )
    end
    
  end
end
