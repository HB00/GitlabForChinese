module SortingHelper
  def sort_options_hash
    {
      sort_value_name => sort_title_name,
      sort_value_recently_updated => sort_title_recently_updated,
      sort_value_oldest_updated => sort_title_oldest_updated,
      sort_value_recently_created => sort_title_recently_created,
      sort_value_oldest_created => sort_title_oldest_created,
      sort_value_milestone_soon => sort_title_milestone_soon,
      sort_value_milestone_later => sort_title_milestone_later,
      sort_value_due_date_soon => sort_title_due_date_soon,
      sort_value_due_date_later => sort_title_due_date_later,
      sort_value_largest_repo => sort_title_largest_repo,
      sort_value_recently_signin => sort_title_recently_signin,
      sort_value_oldest_signin => sort_title_oldest_signin,
      sort_value_downvotes => sort_title_downvotes,
      sort_value_upvotes => sort_title_upvotes,
      sort_value_priority => sort_title_priority
    }
  end

  def projects_sort_options_hash
    options = {
      sort_value_name => sort_title_name,
      sort_value_recently_updated => sort_title_recently_updated,
      sort_value_oldest_updated => sort_title_oldest_updated,
      sort_value_recently_created => sort_title_recently_created,
      sort_value_oldest_created => sort_title_oldest_created
    }

    if current_controller?('admin/projects')
      options.merge!(sort_value_largest_repo => sort_title_largest_repo)
    end

    options
  end

  def member_sort_options_hash
    {
      sort_value_access_level_asc => sort_title_access_level_asc,
      sort_value_access_level_desc => sort_title_access_level_desc,
      sort_value_last_joined => sort_title_last_joined,
      sort_value_oldest_joined => sort_title_oldest_joined,
      sort_value_name => sort_title_name_asc,
      sort_value_name_desc => sort_title_name_desc,
      sort_value_recently_signin => sort_title_recently_signin,
      sort_value_oldest_signin => sort_title_oldest_signin
    }
  end

  def sort_title_priority
    '优先的'
  end

  def sort_title_oldest_updated
    '最早更新的'
  end

  def sort_title_recently_updated
    '最近更新的'
  end

  def sort_title_oldest_created
    '最早创建的'
  end

  def sort_title_recently_created
    '最近创建的'
  end

  def sort_title_milestone_soon
    '最近的里程碑'
  end

  def sort_title_milestone_later
    '最早的里程碑'
  end

  def sort_title_due_date_soon
    '最近的'
  end

  def sort_title_due_date_later
    '最早的'
  end

  def sort_title_name
    '名称'
  end

  def sort_title_largest_repo
    '最大的仓库'
  end

  def sort_title_recently_signin
    '最近登录'
  end

  def sort_title_oldest_signin
    '最早登录'
  end

  def sort_title_downvotes
    '最不受欢迎'
  end

  def sort_title_upvotes
    '最受欢迎'
  end

  def sort_title_last_joined
    'Last joined'
  end

  def sort_title_oldest_joined
    'Oldest joined'
  end

  def sort_title_access_level_asc
    'Access level, ascending'
  end

  def sort_title_access_level_desc
    'Access level, descending'
  end

  def sort_title_name_asc
    'Name, ascending'
  end

  def sort_title_name_desc
    'Name, descending'
  end

  def sort_value_last_joined
    'last_joined'
  end

  def sort_value_oldest_joined
    'oldest_joined'
  end

  def sort_value_access_level_asc
    'access_level_asc'
  end

  def sort_value_access_level_desc
    'access_level_desc'
  end

  def sort_value_name_desc
    'name_desc'
  end

  def sort_value_priority
    '优先的'
  end

  def sort_value_oldest_updated
    '最早更新的'
  end

  def sort_value_recently_updated
    '最近更新的'
  end

  def sort_value_oldest_created
    '最早创建的'
  end

  def sort_value_recently_created
    '最近创建的'
  end

  def sort_value_milestone_soon
    '最早的里程碑'
  end

  def sort_value_milestone_later
    '最近的里程碑'
  end

  def sort_value_due_date_soon
    '最早的'
  end

  def sort_value_due_date_later
    '最近的'
  end

  def sort_value_name
    '名称'
  end

  def sort_value_largest_repo
    '最大的仓库'
  end

  def sort_value_recently_signin
    '最近登录'
  end

  def sort_value_oldest_signin
    '最早登录'
  end

  def sort_value_downvotes
    '最不受欢迎'
  end

  def sort_value_upvotes
    '最受欢迎'
  end
end
