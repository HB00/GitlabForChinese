module Gitlab
  module Ci
    module Status
      module Build
        class Play < SimpleDelegator
          include Status::Extended

          def text
            '手动'
          end

          def label
            '手动运行'
          end

          def icon
            'icon_status_manual'
          end

          def group
            'manual'
          end

          def has_action?
            can?(user, :update_build, subject)
          end

          def action_icon
            'play'
          end

          def action_title
            '运行'
          end

          def action_class
            'ci-play-icon'
          end

          def action_path
            play_namespace_project_build_path(subject.project.namespace,
                                              subject.project,
                                              subject)
          end

          def action_method
            :post
          end

          def self.matches?(build, user)
            build.playable? && !build.stops_environment?
          end
        end
      end
    end
  end
end
