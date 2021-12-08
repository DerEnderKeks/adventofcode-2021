# frozen_string_literal: true

input = File.read('.input.txt')

pos = 0
depth = 0
aim = 0

input.lines(chomp: true).each do |l|
  dir, amount = l.split ' '
  amount = Integer amount
  case dir[0]
  when 'f'
    pos += amount
    depth += aim * amount
  when 'u'
    aim -= amount
  when 'd'
    aim += amount
  end
end

print "P1: #{pos * aim} P2: #{pos * depth}"
