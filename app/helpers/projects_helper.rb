module ProjectsHelper
  def badge_markup
    @badge_markup ||= BadgeMarkup.new(@project, @branch)
  end

  def escape_markdown(str)
    str.to_s.gsub('_', '\_')
  end

  def github_issue_url(options = {})
    title = ''
    if project = options[:project]
      title = "Re: #{project.name}"
    end
    if code_object = options[:code_object]
      title = "Re: #{project.name} [#{code_object.grade}] #{code_object.fullname}"
    end
    "https://github.com/inch-ci/inch_ci-web/issues/new?title=#{title}"
  end

  def link_to_build_history(project)
    url = project_build_history_path(project)
    link = link_to(t("projects.topbar.info.builds_link"), url)
    t("projects.topbar.info.builds_all", :link => link).html_safe
  end

  def link_to_project(project)
    link_to project.name, project_page_path(project)
  end

  def link_to_branch(branch)
    project = branch.project
    link_to truncate(branch.name), project_page_path(project, branch.name)
  end

  def link_to_revision(revision)
    branch = revision.branch
    project = branch.project
    link_to revision.uid[0..7], project_page_path(project, branch.name, revision.uid)
  end

  def link_to_with_hostname(url, options)
    hostname = URI.parse(url).host.gsub(/^www\./, '')
    link_to hostname, url, options
  end
end
