class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  scope :admin, -> { find_by(admin: true) }

  has_many :loans, dependent: :destroy       
  after_create :update_amount

  validates :email, presence: true

  def is_admin?
    self.admin
  end


  private

  def update_amount
    update(amount: 10000) if !self.admin
  end
end
