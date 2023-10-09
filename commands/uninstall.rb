require 'open3'
require 'fileutils'
require './library/colors.rb'

def uninstall_package_with_pip(package_name)
  begin
    completed_process = Open3.capture2e("pip3 uninstall -y #{package_name}")
    if completed_process[1].include?("WARNING: Skipping")
      puts "#{COLOR_RED}pip3 uninstallation of #{package_name} failed#{COLOR_END}"
      return false
    end
    puts "#{COLOR_GREEN}Successfully uninstalled #{package_name} using pip3#{COLOR_END}"
    return true
  rescue
    puts "#{COLOR_RED}pip3 uninstallation of #{package_name} failed#{COLOR_END}"
    return false
  end
end

def uninstall_package_with_apt(package_name)
  begin
    Open3.capture2e("sudo apt remove -y #{package_name}")
    puts "#{COLOR_GREEN}Successfully uninstalled #{package_name} using apt#{COLOR_END}"
    return true
  rescue
    puts "#{COLOR_RED}apt uninstallation of #{package_name} failed#{COLOR_END}"
    return false
  end
end

def uninstall_downloaded_package(package_name)
  if File.exist?(package_name)
    begin
      if File.directory?(package_name)
        FileUtils.rm_rf(package_name)
      else
        File.delete(package_name)
      end
      puts "#{COLOR_GREEN}Successfully removed #{package_name}#{COLOR_END}"
      return true
    rescue => e
      puts "#{COLOR_RED}Failed to remove #{package_name}: #{e.message}#{COLOR_END}"
      return false
    end
  end
  return false
end

def uninstall_package(package_name, method)
    case method
    when 'pip'
      success = uninstall_package_with_pip(package_name)
      if success
        puts "#{COLOR_GREEN}Successfully uninstalled #{package_name} using pip3#{COLOR_END}"
      else
        puts "#{COLOR_RED}Failed to uninstall #{package_name} using pip3#{COLOR_END}"
      end
    when 'apt'
      success = uninstall_package_with_apt(package_name)
      if success
        puts "#{COLOR_GREEN}Successfully uninstalled #{package_name} using apt#{COLOR_END}"
      else
        puts "#{COLOR_RED}Failed to uninstall #{package_name} using apt#{COLOR_END}"
      end
    when 'downloaded'
      success = uninstall_downloaded_package(package_name)
      if success
        puts "#{COLOR_GREEN}Successfully uninstalled #{package_name}#{COLOR_END}"
      else
        puts "#{COLOR_RED}Failed to uninstall #{package_name}#{COLOR_END}"
      end
    else
      puts "#{COLOR_RED}Invalid uninstallation method: #{method}#{COLOR_END}"
    end
  end
  

def main
  args = ARGV
  if args.length >= 2
    package_name = args[0]
    method = args[1]
    uninstall_package(package_name, method)
  else
    puts "#{COLOR_RED}Usage: uninstall <package_name> <method>#{COLOR_END}"
  end
end

if __FILE__ == $0
  main
end
