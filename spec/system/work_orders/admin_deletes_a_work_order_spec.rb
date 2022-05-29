require 'rails_helper'

describe "Admin deleta uma Ordem de serviço" do
  it "sem afetar as demais" do
    transport_company = TransportCompany.create!(trading_name: "SEDEX", company_name: "SEDEX DISTRIBUICOES LTDA", domain: "sedex.com.br", registration_number: "34028316000103", full_address: "Rua dos Andares, 294")
    second_transport_company = TransportCompany.create!(trading_name: "TEDEX", company_name: "TEDEX DISTRIBUICOES LTDA", domain: "tedex.com.br", registration_number: "12028316000103", full_address: "Rua dos Andares, 294")

    admin = Admin.create!(email:"joao@sistemadefrete.com.br", password:"123456")
    login_as(admin, scope: :admin)

    allow(SecureRandom).to receive(:alphanumeric).and_return('ANS82HJCBAS')

    Price.create!(cubic_meters_min: 0.001, cubic_meters_max: 0.900, weight_min:0.1, weight_max:29.99, value_per_km:3.25, transport_company:transport_company)
    Price.create!(cubic_meters_min: 0.001, cubic_meters_max: 2.900, weight_min:30, weight_max:100, value_per_km:7.25, transport_company:transport_company)
    DeliveryTime.create!(km_min:1, km_max: 49, time: 2, transport_company: transport_company)
    DeliveryTime.create!(km_min:50, km_max: 100, time: 7, transport_company: transport_company)

    Price.create!(cubic_meters_min: 0.001, cubic_meters_max: 0.900, weight_min:0.1, weight_max:29.99, value_per_km:3.25, transport_company:second_transport_company)
    Price.create!(cubic_meters_min: 0.001, cubic_meters_max: 2.900, weight_min:30, weight_max:100, value_per_km:7.25, transport_company:second_transport_company)
    DeliveryTime.create!(km_min:1, km_max: 49, time: 2, transport_company: second_transport_company)
    DeliveryTime.create!(km_min:50, km_max: 100, time: 7, transport_company: transport_company)

    WorkOrder.create!(sender_address: "Rua dos Andares, 121", receiver_address: "Rua Dos Felícios, 91", receiver_name: "Márcio Andrade", receiver_cpf: "43330123456", cubic_size: 0.3, total_weight: 12, total_distance: 3, transport_company: transport_company)

    WorkOrder.create!(sender_address: "Rua dos Andares, 121", receiver_address: "Rua Dos Felícios, 91", receiver_name: "Márcio Andrade", receiver_cpf: "43330123456", cubic_size: 0.4, total_weight: 5, total_distance: 313123, transport_company: second_transport_company)

    visit(root_path)

    click_on("Ordens de serviço")


    within(".c-line1") do
      expect(page).to have_content("TEDEX")
      expect(page).to have_content("Tempo Estimado de Envio: X")
    end

    within(".c-line0") do
      expect(page).to have_content("SEDEX")
      expect(page).to have_content("Tempo Estimado de Envio: 2 dias úteis")
      click_on("Ver detalhes")
    end

    expect(page).to have_content("pendente")

    click_on("Deletar")

    expect(page).to have_content("Ordem de serviço deletada com sucesso!")

    expect(page).to have_content("TEDEX")
    expect(page).not_to have_content("SEDEX")
  end

  it "apenas se seu status for 'pendente' ou 'recusada'" do
    transport_company = TransportCompany.create!(trading_name: "SEDEX", company_name: "SEDEX DISTRIBUICOES LTDA", domain: "sedex.com.br", registration_number: "34028316000103", full_address: "Rua dos Andares, 294")

    admin = Admin.create!(email:"joao@sistemadefrete.com.br", password:"123456")
    login_as(admin, scope: :admin)

    allow(SecureRandom).to receive(:alphanumeric).and_return('ANS82HJCBAS')

    Price.create!(cubic_meters_min: 0.001, cubic_meters_max: 0.900, weight_min:0.1, weight_max:29.99, value_per_km:3.25, transport_company:transport_company)

    DeliveryTime.create!(km_min:1, km_max: 49, time: 2, transport_company: transport_company)
    WorkOrder.create!(sender_address: "Rua dos Andares, 121", receiver_address: "Rua Dos Felícios, 91", receiver_name: "Márcio Andrade", receiver_cpf: "43330123456", cubic_size: 0.3, total_weight: 12, total_distance: 3, transport_company: transport_company)

    WorkOrder.last.aceita!

    visit(root_path)

    click_on("Ordens de serviço")

    click_on("#ANS82HJCBAS")

    expect(page).not_to have_content("pendente")

    click_on("Deletar")

    expect(path).not_to eq(work_orders_path)

    expect(page).to have_content("#ANS82HJCBAS")
    expect(page).to have_content("Não é permitido alterar Ordens de serviço que seu estado não sejam 'pendente' ou 'recusada'")
  end
end

