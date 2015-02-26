# encoding: utf-8

require 'benchmark/ips'

ords = 100.times.map { 44_032 + rand(55_203 - 44_032 + 1) }

def consonants_operation(ord)
  index = ord - 44_032
  [index / (21 * 28),
   (index / 28) % 21,
   index % 28]
end

def consonants_divmod(ord)
  initial_medial, final = (ord - 44_032).divmod(28)
  initial, medial = initial_medial.divmod(21)
  [initial, medial, final]
end

Benchmark.ips do |x|
  x.report('operations') { ords.map { |n| consonants_operation(n) } }
  x.report('divmod') { ords.map { |n| consonants_divmod(n) } }
  x.compare!
end
