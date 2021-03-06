require 'rails_helper'

describe 'Usuário aceita uma ordem de serviço' do
  it 'com sucesso' do
    transport_company = TransportCompany.create!(trading_name: "SEDEX", company_name: "SEDEX DISTRIBUICOES LTDA", domain: "sedex.com.br", registration_number: "34028316000103", full_address: "Rua dos Andares, 294")

    user = User.create!(email:"joao@sedex.com.br", password:"123456")
    login_as(user, scope: :user)

    allow(SecureRandom).to receive(:alphanumeric).and_return('ANS82HJCBAS')

    Price.create!(cubic_meters_min: 0.001, cubic_meters_max: 0.900, weight_min:0.1, weight_max:29.99, value_per_km:3.25, transport_company:transport_company)
    DeliveryTime.create!(km_min:1, km_max: 49, time: 2, transport_company: transport_company)
    WorkOrder.create!(sender_address: "Rua dos Andares, 121", receiver_address: "Rua Dos Felícios, 91", receiver_name: "Márcio Andrade", receiver_cpf: "43330123456", cubic_size: 0.3, total_weight: 12, total_distance: 3, transport_company: transport_company)


    visit(root_path)

    click_on("Ordens de serviço")

    within(".c-line0") do
      expect(page).to have_content("#ANS82HJCBAS")
      expect(page).to have_content("Transportadora: SEDEX")
      expect(page).to have_content("Tempo Estimado de Envio: 2 dias úteis")
      click_on("Ver detalhes")
    end

    expect(page).to have_content("pendente")

    within(".navigation-area") do
      expect(page).not_to have_content("Registrar Atualização de rota")
      click_on("Recusar Ordem de serviço")
    end

    expect(page).to have_content("Ordem de serviço foi recusada com sucesso!")
    expect(page).to have_content("recusada")
    expect(page).not_to have_content("Registrar Atualização de rota")

  end
end
