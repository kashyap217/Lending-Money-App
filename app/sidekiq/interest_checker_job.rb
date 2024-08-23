class InterestCheckerJob
  include Sidekiq::Job

  def perform(*args)
    admin = User.admin
    Loan.where(parent_id: nil, status: 'open').includes(:user).each do |loan|
      interest_rate =  loan.amount * loan.interest_rate/100
      loan.update(total_amount: loan.total_amount + interest_rate)
      user = loan.user
      if loan.total_amount > user.amount
        admin_amount_credited = admin.amount +  user.amount
        user.update(amount: 0)
        admin.update(amount: admin_amount_credited)
      end
    end
  end
end
