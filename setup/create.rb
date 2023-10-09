folder_name = "CMDR"
folder_path = File.expand_path("~/#{folder_name}")

begin
  Dir.mkdir(folder_path)
  puts "Directory created at #{folder_path}."
rescue Errno::EEXIST
    puts "Directory already exists at #{folder_path}."
rescue => e
  puts "Error: #{e}"
end