# encoding: utf-8
# Name: Module Lang
# Size: 60
Dir.glob('Lang/*.rb').sort.each do |file|
  load(file)
end