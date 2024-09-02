class EmployeeSalary
  attr_accessor :monthly_salary, :cit, :life_insurance_premium, :house_insurance_premium, :health_insurance_premium, :donation, :marital_status, :sst, :month
  
  def initialize(monthly_salary, cit = 0, life_insurance_premium = 0, house_insurance_premium = 0, health_insurance_premium = 0, donation = 0, marital_status = "s", sst = 0, month = 12)
    @monthly_salary = monthly_salary
    @cit = cit
    @life_insurance_premium = life_insurance_premium
    @house_insurance_premium = house_insurance_premium
    @health_insurance_premium = health_insurance_premium
    @donation = donation
    @marital_status = marital_status.downcase
    @sst = sst
    @month = month
  end
  
  def calculate_monthly_salary
    @monthly_salary
  end

  def calculate_total_salary
    @monthly_salary * 12
  end

  def calculate_bonus_and_other
    @monthly_salary * 0.60
  end

  def calculate_ssf_employer_contribution
    calculate_total_salary * 0.60 * 0.20
  end

  def calculate_total_estimated_annual_salary
    calculate_total_salary + calculate_bonus_and_other + calculate_ssf_employer_contribution
  end

  def calculate_retirement_fund_contribution
    calculate_ssf_employer_contribution / 20 * 31
  end

  def calculate_adjusted_taxable_income
    h2 = calculate_total_estimated_annual_salary
    i2 = calculate_retirement_fund_contribution
    j2 = @cit
    k2 = @life_insurance_premium
    l2 = @house_insurance_premium
    m2 = @health_insurance_premium

    min1 = [h2 / 3, i2 + j2, 500_000].min
    min2 = [k2, 40_000].min
    min3 = [l2, 5_000].min
    min4 = [m2, 20_000].min

    h2 - min1 - min2 - min3 - min4
  end

  def calculate_contribution_deduction
    h2 = calculate_total_estimated_annual_salary
    i2 = calculate_retirement_fund_contribution
    j2 = @cit
    k2 = @life_insurance_premium
    l2 = @house_insurance_premium
    m2 = @health_insurance_premium
    n2 = calculate_adjusted_taxable_income
    o2 = @donation
    
    min1 = [h2 / 3, i2 + j2, 500_000].min
    min2 = [k2, 40_000].min
    min3 = [l2, 5_000].min
    min4 = [m2, 20_000].min
    min5 = [o2, 100_000, 0.05 * n2].min

    min1 + min2 + min3 + min4 + min5
  end

  def calculate_annual_taxable
    h2 = calculate_total_estimated_annual_salary
    p2 = calculate_contribution_deduction

    h2 - p2
  end

  def marital_status_type
    @marital_status == "m" ? "Married" : "Single"
  end

  def calculate_tds
    q2 = calculate_annual_taxable

    if @marital_status == "m" # Married
      case q2
      when 0..600_000 then 0
      when 600_001..800_000 then (q2 - 600_000) * 0.10
      when 800_001..1_100_000 then 20_000 + (q2 - 800_000) * 0.20
      when 1_100_001..2_000_000 then 80_000 + (q2 - 1_100_000) * 0.30
      else 350_000 + (q2 - 2_000_000) * 0.36
      end
    else # Single
      case q2
      when 0..500_000 then 0
      when 500_001..700_000 then (q2 - 500_000) * 0.10
      when 700_001..1_000_000 then 20_000 + (q2 - 700_000) * 0.20
      when 1_000_001..2_000_000 then 80_000 + (q2 - 1_000_000) * 0.30
      else 380_000 + (q2 - 2_000_000) * 0.36
      end
    end
  end

  def calculate_cit_contribution
    @cit / 12
  end

  def calculate_ssf_contribution
    i2 = calculate_retirement_fund_contribution
    (i2 / 0.31) * 0.11 / 12
  end

  def calculate_monthly_tax
    (calculate_tds / @month).ceil
  end

  def calculate_salary_payable
    (calculate_monthly_salary - calculate_monthly_tax - calculate_ssf_contribution - calculate_cit_contribution).floor
  end
end

print "Enter the monthly salary: "
monthly_salary = gets.chomp.to_f

print "Enter CIT (or press Enter to skip): "
cit = gets.chomp.to_f

print "Enter Life Insurance Premium (or press Enter to skip): "
life_insurance_premium = gets.chomp.to_f

print "Enter House Insurance Premium (or press Enter to skip): "
house_insurance_premium = gets.chomp.to_f

print "Enter Health Insurance Premium (or press Enter to skip): "
health_insurance_premium = gets.chomp.to_f

print "Enter Donation (or press Enter to skip): "
donation = gets.chomp.to_f

print "Enter Marital Status (M for Married, S for Single): "
marital_status = gets.chomp.downcase

print "Enter SST (or press Enter to skip): "
sst = gets.chomp.to_f

print "Enter the number of months (default is 12): "
month = gets.chomp.to_i
month = 12 if month.zero?

employee = EmployeeSalary.new(monthly_salary, cit, life_insurance_premium, house_insurance_premium, health_insurance_premium, donation, marital_status, sst, month)

puts "Monthly Salary: #{employee.calculate_monthly_salary}"
puts "Total Salary for the Year: #{employee.calculate_total_salary}"
puts "Bonus and Other: #{employee.calculate_bonus_and_other}"
puts "SSF Employer Contribution: #{employee.calculate_ssf_employer_contribution}"
puts "Total Estimated Annual Salary: #{employee.calculate_total_estimated_annual_salary}"
puts "Contribution to Retirement Fund: #{employee.calculate_retirement_fund_contribution}"
puts "Adjusted Taxable Income: #{employee.calculate_adjusted_taxable_income}"
puts "Contribution Deduction: #{employee.calculate_contribution_deduction}"
puts "Annual Taxable: #{employee.calculate_annual_taxable}"
puts "Marital Status: #{employee.marital_status_type}"
puts "TDS: #{employee.calculate_tds}"
puts "CIT Contribution: #{employee.calculate_cit_contribution}"
puts "SSF Contribution: #{employee.calculate_ssf_contribution}"
puts "Monthly Tax: #{employee.calculate_monthly_tax}"
puts "Salary Payable: #{employee.calculate_salary_payable}"
