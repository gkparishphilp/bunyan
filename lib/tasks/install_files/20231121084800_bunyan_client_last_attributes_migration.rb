class BunyanClientLastAttributesMigration < ActiveRecord::Migration[7.1]
  def change
    change_table :bunyan_clients do |t|
      t.string "last_referrer_url", default: nil
      t.string "last_referrer_host", default: nil
      t.string "last_referrer_path", default: nil
      t.string "last_lander_url", default: nil
      t.string "last_lander_host", default: nil
      t.string "last_lander_path", default: nil
      t.string "last_campaign_source", default: nil
      t.string "last_campaign_medium", default: nil
      t.string "last_campaign_term", default: nil
      t.string "last_campaign_content", default: nil
      t.string "last_campaign_name", default: nil
      t.integer "last_campaign_cost", default: nil
      t.string "last_partner_source", default: nil
      t.string "last_partner_id", default: nil
      t.string "last_referrer_params", default: nil
      t.string "last_lander_params", default: nil
      t.datetime "last_landed_at", default: nil
    end

  end
end
