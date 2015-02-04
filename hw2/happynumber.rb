def sum_of_divisor(number)
  sum = 0
  for i in 1..number/2
    if number%i == 0
      sum += i
    end
  end
  return sum
end

puts "All the pairs of perfect numbers are : "

for i in 2..10000
  if ( sum_of_divisor( sum_of_divisor(i))==i) 
    if ( sum_of_divisor(i) != i)
      puts "#{i} - #{getSumDivisor(i)}"
    end
  end
end
