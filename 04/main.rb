# frozen_string_literal: true

input = File.read('.input.txt')
lines = input.lines chomp: true

numbers = lines[0].split(',').map { |n| Integer n }
lines.delete_at 0

boards = []
lines.filter { |l| l.length.positive? }.each_slice(5).with_index do |lines, i|
  boards[i] = Array.new(5) { Array.new 5 }
  lines.each_with_index do |l, x|
    l.split(' ').each_with_index do |n, y|
      boards[i][x][y] = Integer n
    end
  end
end

def run_bingo(numbers, boards)
  marked_boards = Array.new(boards.length) { Array.new(5) { Array.new 5 } }

  numbers.each do |draw_number|
    boards.each_with_index do |b, bi|
      b.each_with_index do |row, ri|
        row.each_with_index do |n, ci|
          marked_boards[bi][ri][ci] = n if n == draw_number
        end
        row_filtered = marked_boards[bi][ri].filter(&:nil?)

        next unless row_filtered.length.zero?

        return [bi, draw_number, marked_boards]
      end

      (0..4).each do |col|
        col_nils = 0
        (0..4).each do |row|
          col_nils += 1 if marked_boards[bi][row][col].nil?
        end
        next unless col_nils.zero?

        return [bi, draw_number, marked_boards]
      end
    end
  end
end

def calc_score(boards, winner, winner_number, marked_boards)
  score = 0
  boards[winner].each_with_index do |row, ri|
    row -= marked_boards[winner][ri]
    score += row.reduce 0, :+
  end
  score * winner_number
end

first_score = -1
last_score = -1

boards.length.times do |i|
  winner, winner_number, marked_boards = run_bingo(numbers, boards)
  first_score = calc_score boards, winner, winner_number, marked_boards if i == 1
  last_score = calc_score boards, winner, winner_number, marked_boards if boards.length == 1
  boards.delete_at winner
  break if boards.length.zero?
end

print "P1: #{first_score} P2: #{last_score}"
