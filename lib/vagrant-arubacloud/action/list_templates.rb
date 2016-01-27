module VagrantPlugins
  module ArubaCloud
    module Action
      class ListTemplates
        def initialize(app, env)
          @app = app
        end

        def call(env)
          compute_service = env[:arubacloud_compute]
          env[:ui].info ('%-40s %-60s %s' % ['Template Name', 'Description', 'ID'])
          compute_service.templates.get_hypervisor(hv=4).sort_by(&:name).each do |template|
            env[:ui].info ('%-40s %-60s %s' % [template.name, template.description, template.id])
          end
          @app.call(env)
        end
      end
    end
  end
end
