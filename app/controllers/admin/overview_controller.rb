class Admin::OverviewController < ApplicationController
  layout 'admin'

  def index
    set_stats
    set_projects
  end

  private

  DAYS_BACK = 30
  def set_stats
    list = Statistics.where("date > ?", (DAYS_BACK + 1).days.ago).order('date ASC')
    map = {}
    list.each do |stat|
      date = stat.date.midnight
      map[date] ||= {'date' => date.strftime("%Y-%m-%d")}
      map[date][stat.name] = stat.value
    end
    @stats_headers = %w(Day Date Badges Users Hooks Users Repos Users)
    @stats = map.keys.sort.map do |date|
      stats = map[date]
      shown_date = date - 1
      [
        shown_date.strftime("%a"),
        shown_date.strftime("%Y-%m-%d"),
        val(stats, 'projects:badges'),
        val(stats, 'maintainers:badges'),
        val(stats, 'projects:hooked'),
        val(stats, 'maintainers:hooked'),
        val(stats, 'projects:all'),
        val(stats, 'maintainers:all'),
      ]
    end
    @stats_badges = Statistics.where(:name => 'projects:badges').last.value
    @stats_chart_data = map.values
  end

  def set_projects
    @new_projects = Project.order('created_at ASC').last(30)
  end

  def val(stats, key, add_change = true)
    @old_stats ||= {}
    value = stats[key]
    change = value - @old_stats[key].to_i
    change = "+#{change}" if change > 0
    @old_stats[key] = value
    result = value.to_s
    result << " (#{change})" if add_change
    result
  end

end
