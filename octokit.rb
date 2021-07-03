require "bundler/setup"
require 'octokit'

class Search_issue

  def initialize(token)
    @client = Octokit::Client.new(access_token: token)
  end

  def done(repo_name)
    page_num = 1
    i = 1
    api_issues = fetch_issues(repo_name, page_num)
    while api_issues.count % 30 == 0
      sleep 60 if i % 10 == 0
      page_num += 1
      api_issues.concat(fetch_issues(repo_name, page_num))
    end
    puts api_issues
  end

  def fetch_issues(repo_name, page)
    options = {
      state: 'all',
      per_page: 30,
      page: page
    }
    @client.list_issues(repo_name, options)
  end
end

puts 'Githubのアクセストークンを入力してください'
token = gets.chomp.to_s
obj = Search_issue.new(token)
puts "検索したいリポジトリネームを入れてください\n例: your name/your repository name"
repo_name = gets.chomp.to_s
puts obj.done(repo_name)
