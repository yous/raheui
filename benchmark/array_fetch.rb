# encoding: utf-8

require 'benchmark/ips'

matrix = [[0, 1, 2],
          [3, 4, 5],
          [6, 7, 8]]

Benchmark.ips do |x|
  x.report('fetch with no block') { matrix.fetch(0, []) }
  x.report('fetch with a block') { matrix.fetch(0) { [] } }
  x.report('brackets with an ||') { matrix[0] || [] }
  x.compare!
end
