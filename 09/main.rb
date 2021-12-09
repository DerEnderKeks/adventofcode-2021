# frozen_string_literal: true
require 'set'

input = File.read '.input.txt'

map = input.lines(chomp: true).map { |l| l.split(//).map { |n| Integer n } }

max_x = map[0].length - 1
max_y = map.length - 1

low_points = []

# src: https://gist.github.com/makevoid/3918299
# rubocop:disable all
def hsv_to_rgb(h, s, v)
  h, s, v = h.to_f / 360, s.to_f / 100, v.to_f / 100
  h_i = (h * 6).to_i
  f = h * 6 - h_i
  p = v * (1 - s)
  q = v * (1 - f * s)
  t = v * (1 - (1 - f) * s)
  r, g, b = v, t, p if h_i == 0
  r, g, b = q, v, p if h_i == 1
  r, g, b = p, v, t if h_i == 2
  r, g, b = p, q, v if h_i == 3
  r, g, b = t, p, v if h_i == 4
  r, g, b = v, p, q if h_i == 5
  [(r * 255).to_i, (g * 255).to_i, (b * 255).to_i]
end
# rubocop:enable all

map.each_with_index do |row, y|
  row.each_with_index do |n, x|
    unless y.positive? && map[y - 1][x] <= n ||
           y < max_y && map[y + 1][x] <= n ||
           x.positive? && map[y][x - 1] <= n ||
           x < max_x && map[y][x + 1] <= n
      low_points.append({ x: x, y: y, n: n })
    end
    r, g, b = hsv_to_rgb 36 * n, 60, 80
    print "\e[38;2;#{r};#{g};#{b}m#{n}\e[0m"
  end
  puts ''
end

basins = []

def probe_point(map, point, previous_point)
  points = [[point[:x], point[:y]]].to_set
  max_y = map.length - 1
  max_x = map[0].length - 1

  [[1, 0], [0, 1], [-1, 0], [0, -1]].each do |offset|
    test_x = point[:x] + offset[0]
    test_y = point[:y] + offset[1]
    next if previous_point[:x] == test_x && previous_point[:y] == test_y ||
            test_x.negative? || test_x > max_x || test_y.negative? || test_y > max_y

    test_height = map[test_y][test_x]
    next if test_height <= point[:n] || test_height == 9

    points.merge probe_point(map, { x: test_x, y: test_y, n: test_height }, point)
  end

  points
end

low_points.each do |point|
  basins.append probe_point(map, point, point).length
end

risk_score = low_points.reduce(0) { |sum, p| sum + p[:n] + 1 }
p2_value = basins.sort.reverse.first(3).reduce :*

print "\nP1: #{risk_score} P2: #{p2_value}"
