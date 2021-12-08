# frozen_string_literal: true

input = File.read('.input.txt')

counts = Hash.new 0
outputs = []

def split_sort(string)
  string.split(' ').map { |s| s.split(//).sort.join('') }
end

input.lines(chomp: true).each do |line|
  split_line = line.split '|'
  input_digits = split_sort(split_line[0]).sort_by!(&:length)
  output = split_sort(split_line[1])

  decoded_digits = {}

  decoded_digits[1] = input_digits.find { |d| d.length == 2 }
  decoded_digits[7] = input_digits.find { |d| d.length == 3 }
  decoded_digits[4] = input_digits.find { |d| d.length == 4 }
  decoded_digits[8] = input_digits.find { |d| d.length == 7 }

  decoded_digits[5] = input_digits.find do |d|
    split = d.split(//)
    split.length == 5 and
      (split - decoded_digits[4].split(//)).length == 2 and
      (split - decoded_digits[1].split(//)).length == 4
  end

  decoded_digits[2] = input_digits.find do |d|
    split = d.split(//)
    split.length == 5 and
      (split - decoded_digits[5].split(//)).length == 2
  end

  decoded_digits[3] = input_digits.find do |d|
    split = d.split(//)
    split.length == 5 and
      (split - decoded_digits[5].split(//)).length == 1
  end

  decoded_digits[6] = input_digits.find do |d|
    split = d.split(//)
    split.length == 6 and
      (split - decoded_digits[5].split(//)).length == 1 and
      (split - decoded_digits[1].split(//)).length == 5
  end

  decoded_digits[0] = input_digits.find do |d|
    split = d.split(//)
    split.length == 6 and
      (split - decoded_digits[5].split(//)).length == 2 and
      (split - decoded_digits[3].split(//)).length == 2
  end

  decoded_digits[9] = input_digits.find do |d|
    d.length == 6 and
      d != decoded_digits[6] and
      d != decoded_digits[0]
  end

  output_decoded = 0
  output.each_with_index do |o, i|
    digit = decoded_digits.key o
    counts[digit] += 1
    output_decoded += digit * 10 ** (3 - i)
  end

  outputs.append output_decoded
end

p1_sum = 0
counts.each { |k, v| p1_sum += v if [1, 4, 7, 8].include? k }

p2_sum = outputs.sum
print "P1: #{p1_sum}\nP2: #{p2_sum}"
