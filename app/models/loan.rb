class Loan < ApplicationRecord
  belongs_to :user
  has_many :adjustments, dependent: :destroy
  has_many :adjustments, class_name: "Loan", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Loan", optional: true

  validates :amount, presence: true
  validates :interest_rate, presence: true
end
