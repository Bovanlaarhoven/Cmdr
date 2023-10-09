require 'open3'
require 'json'
require 'nokogiri'
require 'net/http'

COLOR_GREEN = "\e[32m"
COLOR_YELLOW = "\e[33m"
COLOR_RED = "\e[31m"
COLOR_END = "\e[0m"

def install_package(package_name)
  if try_pip(package_name) || try_wget(package_name) || try_curl(package_name) || try_github(package_name)
    puts "#{COLOR_GREEN}Package #{package_name} successfully downloaded#{COLOR_END}"
  end
end

def try_pip(package_name)
  begin
    Open3.capture2e("pip3 install #{package_name}")
    puts "#{COLOR_GREEN}Successfully installed #{package_name} using pip3#{COLOR_END}"
    return true
  rescue
    puts "#{COLOR_RED}pip3 installation of #{package_name} failed, attempting other methods...#{COLOR_END}"
    return false
  end
end

def try_wget(package_name)
  puts "Trying to download using wget: #{COLOR_YELLOW}#{package_name}#{COLOR_END}"
  begin
    Open3.capture2e("wget #{package_name}")
    return true
  rescue
    puts "#{COLOR_RED}wget download of #{package_name} failed#{COLOR_END}"
    return false
  end
end

def try_curl(package_name)
  puts "Trying to download using curl: #{COLOR_YELLOW}#{package_name}#{COLOR_END}"
  begin
    Open3.capture2e("curl -O #{package_name}")
    return true
  rescue
    puts "#{COLOR_RED}curl download of #{package_name} failed#{COLOR_END}"
    return false
  end
end

def try_github(package_name)
  github = Net::HTTP.get(URI("https://github.com/search?q=#{package_name}&type=repositories"))
  soup = Nokogiri::HTML(github)
  json_data = soup.text.match(/{.*}/).to_s
  data = JSON.parse(json_data)
  results = data.dig("payload", "results")

  if results && !results.empty?
    name = results[0]["hl_name"]
    repo_link = "https://github.com/#{name}.git"
    puts "Cloning #{COLOR_YELLOW}#{repo_link}#{COLOR_END}..."
    Open3.capture2e("git clone #{repo_link}")
    puts "#{COLOR_GREEN}Successfully cloned #{repo_link}#{COLOR_END}"
  else
    puts "#{COLOR_RED}No Git repository found for #{package_name}#{COLOR_END}"
  end
end

def main
  args = ARGV
  if args.length >= 1
    package_name = args[0]
    install_package(package_name)
  end
end

if __FILE__ == $0
  main
end
