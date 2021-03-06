module Commits
  class ChangeService < ::BaseService
    class ValidationError < StandardError; end
    class ChangeError < StandardError; end

    def execute
      @source_project = params[:source_project] || @project
      @target_branch = params[:target_branch]
      @commit = params[:commit]
      @create_merge_request = params[:create_merge_request].present?

      check_push_permissions unless @create_merge_request
      commit
    rescue Repository::CommitError, Gitlab::Git::Repository::InvalidBlobName, GitHooksService::PreReceiveError,
           ValidationError, ChangeError => ex
      error(ex.message)
    end

    private

    def commit
      raise NotImplementedError
    end

    def commit_change(action)
      raise NotImplementedError unless repository.respond_to?(action)

      into = @create_merge_request ? @commit.public_send("#{action}_branch_name") : @target_branch
      tree_id = repository.public_send("check_#{action}_content", @commit, @target_branch)

      if tree_id
        create_target_branch(into) if @create_merge_request

        repository.public_send(action, current_user, @commit, into, tree_id)
        success
      else
        error_msg = "Sorry, we cannot #{action.to_s.dasherize} this #{@commit.change_type_title(current_user)} automatically.
                     A #{action.to_s.dasherize} may have already been performed with this #{@commit.change_type_title(current_user)}, or a more recent commit may have updated some of its content."
        raise ChangeError, error_msg
      end
    end

    def check_push_permissions
      allowed = ::Gitlab::UserAccess.new(current_user, project: project).can_push_to_branch?(@target_branch)

      unless allowed
        raise ValidationError.new('不允许您推送到此分支')
      end

      true
    end

    def create_target_branch(new_branch)
      # Temporary branch exists and contains the change commit
      return success if repository.find_branch(new_branch)

      result = CreateBranchService.new(@project, current_user)
                                  .execute(new_branch, @target_branch, source_project: @source_project)

      if result[:status] == :error
        raise ChangeError, "创建源分支时出错： #{result[:message]}"
      end
    end
  end
end
