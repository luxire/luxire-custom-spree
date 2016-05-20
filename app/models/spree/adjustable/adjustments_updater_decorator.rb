Spree::Adjustable::AdjustmentsUpdater.class_eval do

  def update
    #byebug
    return unless persisted?
    update_promo_adjustments
    update_tax_adjustments
    update_personalization_cost
    persist_totals
  end

private
  def persist_totals
    adjustable.update_columns(
      promo_total: @promo_total,
      included_tax_total: @included_tax_total,
      additional_tax_total: @additional_tax_total,
      adjustment_total: @promo_total + @additional_tax_total + @personalization_cost,
      updated_at: Time.now
    )
  end

def update_personalization_cost
  personalization_records = Spree::Adjustment.where(adjustable: @adjustable).where(source_type: "PersonalizationCost")
  @personalization_cost = 0
  personalization_records.each do |personalization_record|
    @personalization_cost += personalization_record.amount
  end
end

end
