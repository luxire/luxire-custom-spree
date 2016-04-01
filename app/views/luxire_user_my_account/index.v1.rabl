object false
child(@orders => :orders) do
  extends "luxire_user_my_account/show.json.rabl"
end
node(:count) { @orders.count }
node(:current_page) { params[:page] || 1 }
