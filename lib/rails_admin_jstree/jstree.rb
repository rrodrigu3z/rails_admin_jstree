module RailsAdmin
  module Config
    module Actions
      class Jstree < Base
        RailsAdmin::Config::Actions.register(self)

        # Is the action acting on the root level (Example: /admin/contact)
        register_instance_option :root? do
          false
        end

        register_instance_option :collection? do
          true
        end

        # Is the action on an object scope (Example: /admin/team/1/edit)
        register_instance_option :member? do
          false
        end
        
        register_instance_option :link_icon do
          'icon-folder-open'
        end

        register_instance_option :http_methods do
          [:get, :post]
        end
        
        # Controller action
        register_instance_option :controller do
          Proc.new do |klass|
            @model =  @abstract_model.model
            
            # Operation: get_children
            def _get_children
              nodes = params[:id] == 'root' ? @model.roots.order(:position) : @node.children.order(:position)
              render json: nodes, methods: [:data, :attr, :state]
            end
            
            def _create_node
              model_scope = @node ? @node.children : @model
              new_node = model_scope.new nombre: params[:name]
              new_node.position = params[:position]
              
              if new_node.save
                render json: {id: new_node.id, status: 1 }
              else
                render json: { status: 0 }
              end
            end
            
            def _remove_node
              if @node.destroy
                render json: { status: 1 }
              else
                render json: { status: 0 }
              end
            end
            
            def _rename_node
              @node.nombre = params[:name]
              if @node.save
                render json: { status: 1 }
              else
                render json: { status: 0 }
              end
            end
            
            def _move_node
              if params[:parent_id] == 'root'
                @node.parent = nil
              else
                @node.parent = @model.find(params[:parent_id])
              end
              @node.position = params[:position]
              
              if @node.save
                render json: { id: @node.id, status: 1 }
              else
                render json: { status: 0 }
              end
            end
            
            # Process Request. GET
            if request.get?
              
              if params[:operation].nil? # SHOW Tree
                render action: @action.template_name 
              else # Tree GET operations
                @node = @model.find(params[:id]) unless params[:id] == 'root'
                
                # Operations
                case params[:operation].to_sym
                when :get_children
                  _get_children
                when :show_node
                  @object = @node
                  render :jstree_node_details
                end
              end
           
            # Process Request. POST
            elsif request.post?
              
              @node = @model.find(params[:id]) unless params[:id] == 'root'
              
              # Operations
              case params[:operation].to_sym
              when :create_node
                _create_node
              when :remove_node
                _remove_node
              when :rename_node
                _rename_node
              when :move_node
                _move_node  
              end
            end
          end
        end
        
      end
    end
  end
end
