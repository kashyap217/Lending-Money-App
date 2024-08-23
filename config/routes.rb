Rails.application.routes.draw do

  root to: 'loans#index'

  devise_for :users
  resources :users do
    resources :loans
  end

  get 'reject', to: 'loans#reject'
  get 'approve', to: 'loans#approve'
  get 'adjustment', to: 'loans#adjustment'
  get 'repay_loan', to: 'loans#repay_loan'


  get 'requested_list', to: 'loans#requested_list'
  get 'approved_list', to: 'loans#approved_list'
  get 'open_list', to: 'loans#open_list'
  get 'reject_list', to: 'loans#reject_list'
  get 'closed_list', to: 'loans#closed_list'


  get 'data_list', to: 'loans#data_list'

  

end
