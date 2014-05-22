require 'open-uri'

content = open('https://raw.githubusercontent.com/rrrene/inch-pages/master/_projects.yml').read
project_names = YAML.load(content)

COUNT = ENV['COUNT'] || 5

project_names[0...COUNT.to_i].each do |name|
  uid = "github:#{name}"
  repo_url = "git@github.com:#{name}.git"
  InchCI::Store::FindProject.call(uid) ||
    InchCI::Store::CreateProject.call(uid, repo_url)

  InchCI::Worker::Project::Build.enqueue(repo_url)
  InchCI::Worker::Project::UpdateInfo.enqueue(uid)
end

puts "Projects: #{Project.count}"