# encoding: utf-8

require 'benchmark/ips'

ords = 100.times.map { 44_032 + rand(55_203 - 44_032 + 1) }
chars = ords.map { |n| n.chr(Encoding::UTF_8) }

def range_if(char)
  ord = char.ord
  char if 44_032 <= ord && ord <= 55_203
end

def range_case(char)
  case char.ord
  when 44_032..55_203
    char
  end
end

Benchmark.ips do |x|
  x.report('if') { chars.each { |char| range_if(char) } }
  x.report('case') { chars.each { |char| range_case(char) } }
  x.compare!
end
