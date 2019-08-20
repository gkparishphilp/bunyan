class BunyanEventUpdatesMigration < ActiveRecord::Migration[5.1]
	def change

		rename_column :bunyan_events, :target_obj_type, :parent_obj_type
		rename_column :bunyan_events, :target_obj_id, :parent_obj_id
		add_column :bunyan_events, :result_obj_type, :string, default: nil
		add_column :bunyan_events, :result_obj_id, :bigint, default: nil

		add_column :bunyan_clients, :result_obj_id, :bigint, default: nil
		rename_column :bunyan_clients, :referrer_url, :first_referrer_url
		rename_column :bunyan_clients, :referrer_host, :first_referrer_host
		rename_column :bunyan_clients, :referrer_path, :first_referrer_path
		rename_column :bunyan_clients, :lander_url, :first_lander_url
		rename_column :bunyan_clients, :lander_host, :first_lander_host
		rename_column :bunyan_clients, :lander_path, :first_lander_path
		rename_column :bunyan_clients, :campaign_source, :first_campaign_source
		rename_column :bunyan_clients, :campaign_medium, :first_campaign_medium
		rename_column :bunyan_clients, :campaign_term, :first_campaign_term
		rename_column :bunyan_clients, :campaign_content, :first_campaign_content
		rename_column :bunyan_clients, :campaign_name, :first_campaign_name
		rename_column :bunyan_clients, :campaign_cost, :first_campaign_cost
		rename_column :bunyan_clients, :partner_source, :first_partner_source
		rename_column :bunyan_clients, :partner_id, :first_partner_id
		rename_column :bunyan_clients, :referrer_params, :first_referrer_params
		rename_column :bunyan_clients, :lander_params, :first_lander_params

		add_column :bunyan_clients, :last_referrer_url, :string, default: nil
		add_column :bunyan_clients, :last_referrer_host, :string, default: nil
		add_column :bunyan_clients, :last_referrer_path, :string, default: nil
		add_column :bunyan_clients, :last_referrer_params, :string, default: nil
		add_column :bunyan_clients, :last_lander_url, :string, default: nil
		add_column :bunyan_clients, :last_lander_host, :string, default: nil
		add_column :bunyan_clients, :last_lander_path, :string, default: nil
		add_column :bunyan_clients, :last_lander_params, :string, default: nil
		add_column :bunyan_clients, :last_campaign_source, :string, default: nil
		add_column :bunyan_clients, :last_campaign_medium, :string, default: nil
		add_column :bunyan_clients, :last_campaign_term, :string, default: nil
		add_column :bunyan_clients, :last_campaign_content, :string, default: nil
		add_column :bunyan_clients, :last_campaign_name, :string, default: nil
		add_column :bunyan_clients, :last_campaign_cost, :integer, default: nil
		add_column :bunyan_clients, :last_partner_source, :string, default: nil
		add_column :bunyan_clients, :last_partner_id, :string, default: nil

	end
end
