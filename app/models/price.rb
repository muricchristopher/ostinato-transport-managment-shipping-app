class Price < ApplicationRecord
  extend FriendlyId
  friendly_id :slugging, use: [:slugged, :history, :finders]


  belongs_to :transport_company

  validates :cubic_meters_min, :cubic_meters_max, :weight_min, :weight_max, :value_per_km, presence: true
  validates :cubic_meters_min, :cubic_meters_max, :weight_min, :weight_max, :value_per_km, numericality: { greater_than_or_equal_to: 0 }

  validate :cubic_meters_max_cannot_be_less_or_equal_than_cubic_meters_min
  validate :weight_max_cannot_be_less_or_equal_than_weight_min

  def cubic_meters_max_cannot_be_less_or_equal_than_cubic_meters_min
    if cubic_meters_min.present? && cubic_meters_max.present?
      if cubic_meters_min > cubic_meters_max or cubic_meters_min == cubic_meters_max
        errors.add(:cubic_meters_max, "deve ser maior que o Metros Cúbicos Mínimo")
      end
    end
  end
  def weight_max_cannot_be_less_or_equal_than_weight_min
    if weight_min.present? && weight_max.present?
      if weight_min > weight_max or weight_min == weight_max
        errors.add(:weight_max, "deve ser maior que o Peso Mínimo")
      end
    end
  end


  def full_description
    { "Metros Cúbicos" => "#{cubic_meters_min.to_s}m³ á #{cubic_meters_max.to_s}m³", "Peso" => "#{weight_min.to_s}kg á #{weight_max.to_s}kg", "Valor por Km" => "R$#{value_per_km}" }
  end
end
