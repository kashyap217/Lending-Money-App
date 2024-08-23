class LoansController < ApplicationController
  before_action :authenticate_user!
  include LoansHelper

  def index
      if current_user.is_admin?
        @loans = Loan.where(status: requests, parent_id: nil)
      else
        @loans = current_user.loans.where(status: requests, parent_id: nil)
      end
  end

  def show
    @loan = Loan.find_by(id:params[:id])
  end
  
  def new
    @user = User.find_by(id: params[:user_id])
    @loan = Loan.new
    respond_to do |format|
      format.js
    end
  end
  
  def create
    @user = User.find_by(id: params[:user_id])
    loan_params[:total_amount]  = loan_params[:amount]
    @loan = @user.loans.new(loan_params)
    if @loan.save
        redirect_to :root    
    else
      render :new, status: :unprocessable_entity
    end
  end

  def reject
    @loans = current_user.loans.where(status: 'rejected')
    @loan = Loan.find_by(id: params[:id])
    @loan.update(status: 'rejected')
    if request.xhr?
      respond_to do |format|
        format.js
      end
    else
      redirect_to root_path
    end
  end

  def approve
    @loans = current_user.loans.where(status: 'approved')
    admin = User.admin
    if params[:loan_id].present?
      @loan = Loan.find(params[:loan_id])
      final_amount = current_user.amount + @loan.amount
      pending_amount = admin.amount - @loan.amount
      Loan.create(user_id: @loan.user_id, 
                  parent_id: @loan.id, 
                  interest_rate: @loan.interest_rate, 
                  amount: @loan.amount, 
                  status: params[:status])  if params[:status] == 'waiting_for_adjustment_acceptance'
      admin.update(amount: pending_amount)
      current_user.update(amount: final_amount)
      @loan.update(status: 'open')
    else
      @loan = Loan.find_by(id: params[:id])
      @loan.update(status: 'approved')
    end
    if request.xhr?
      respond_to do |format|
        format.js
      end
    else
      redirect_to root_path
    end
  end

  def adjustment
    @loan = Loan.find_by(id: params[:id])
    @user = @loan.user
    respond_to do |format|
      format.js
    end
  end

  def update
    @loan = Loan.find_by(id: params[:id])
    amount= @loan.amount
    interest_rate= @loan.interest_rate
    status= @loan.status
    loan_params[:status] = 'waiting_for_adjustment_acceptance' if loan_params[:status] != 'readjustment'
    loan_params[:total_amount]  = loan_params[:amount]
    if @loan.update(loan_params)
      Loan.create(user_id: @loan.user_id ,parent_id: @loan.id, interest_rate: interest_rate, amount: amount, status: status)
      redirect_to root_path
    else
      render :adjustment, status: :unprocessable_entity
    end
  end


  def repay_loan
    @loan = Loan.find_by(id: params[:id])
    user_balance = @loan.user.amount - @loan.total_amount
    admin_balance = User.admin.amount + @loan.total_amount
    @loan.user.update(amount: user_balance)
    User.admin.update(amount: admin_balance)
    @loan.update(status: 'closed')
    @loans = Loan.where(status: requests, parent_id: nil)
    @loans = @loans.where(user_id: current_user.id) unless current_user.is_admin?
    redirect_to root_path
  end


  def data_list
    fetch_loans(status: params[:status])
    respond_to do |format|
      format.js 
    end
  end

  private
  def loan_params
      params.require(:loan).permit!
  end

  def fetch_loans(status: nil)
    status = requests if status == 'requested'
    @loans = Loan.where(status: status, parent_id: nil)
    @loans = @loans.where(user_id: current_user.id) unless current_user.is_admin?
  end

end
