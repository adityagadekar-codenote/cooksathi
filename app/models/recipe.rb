class Recipe < ApplicationRecord
  belongs_to :user, optional: true
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :favorites, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
  validates :prep_time, presence: true, numericality: { greater_than: 0 }
  validates :diet_type, presence: true, inclusion: { in: %w[veg vegan non-veg] }
  validates :instructions, presence: true
  validates :visibility, presence: true, inclusion: { in: %w[public private] }

  # Virtual attributes for search
  attr_accessor :matched_count, :total_count, :match_percentage, :missing_count

  scope :public_only, -> { where(visibility: 'public') }
  scope :visible_to, ->(user) do
    if user
      where('visibility = ? OR user_id = ?', 'public', user.id)
    else
      where(visibility: 'public')
    end
  end
end
