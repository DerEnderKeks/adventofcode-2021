# frozen_string_literal: true

input = File.read('.input.txt')

scans = input.lines(chomp: true).map { |s| Integer s }

def sliding_sum(array, index)
  array[index - 2] + array[index - 1] + array[index]
end

increases_p1 = 0
increases_p2 = 0
scans.each_with_index do |s, i|
  increases_p1 += 1 if i.positive? && (s >= scans[i - 1])
  increases_p2 += 1 if i >= 3 && (sliding_sum(scans, i) > sliding_sum(scans, i - 1))
end

print "P1: #{increases_p1}\nP2: #{increases_p2}"
