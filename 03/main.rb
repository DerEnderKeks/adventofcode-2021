# frozen_string_literal: true

input = File.read('.input.txt')

lines = input.lines chomp: true

gamma_string = ''

oxygen_lines = lines
co2_lines = lines

(0..lines[0].length - 1).each do |col|
  ones = 0
  zeros = 0
  lines.each { |l| l[col] == '0' ? zeros += 1 : ones += 1 }
  gamma_string += ones > zeros ? '1' : '0'

  ones = 0
  zeros = 0
  oxygen_lines.each { |l| l[col] == '0' ? zeros += 1 : ones += 1 }
  oxygen_lines = oxygen_lines.filter { |l| l[col] == (ones >= zeros ? '1' : '0') } unless oxygen_lines.length == 1

  ones = 0
  zeros = 0
  co2_lines.each { |l| l[col] == '0' ? zeros += 1 : ones += 1 }
  co2_lines = co2_lines.filter { |l| l[col] == (zeros <= ones ? '0' : '1') } unless co2_lines.length == 1
end

epsilon_string = gamma_string.split(//).map { |d| d == '1' ? '0' : '1' }.join
gamma = gamma_string.to_i 2
epsilon = epsilon_string.to_i 2
oxygen = oxygen_lines[0].to_i 2
co2 = co2_lines[0].to_i 2
print "P1: #{gamma * epsilon} P2: #{oxygen * co2}"
