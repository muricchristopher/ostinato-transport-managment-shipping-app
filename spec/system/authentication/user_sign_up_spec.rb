require 'rails_helper'

describe 'Usuário se cadastra' do
  it 'com sucesso' do
    visit(root_path)

    click_on("Entrar")

    click_on("Inscrever-se")

    fill_in("E-mail", with:"gabriel@gmail.com")
    fill_in("Senha", with:"123456")
    fill_in("Confirme sua senha", with:"123456")

    click_on("Cadastrar-se")

    user = User.last

    expect(user.email).to eq("gabriel@gmail.com")

    within("nav") do
      expect(page).to have_content("gabriel@gmail.com")
      expect(page).to have_content("Sair")
      expect(page).to_not have_content("Entrar")
    end

    expect(page).to have_content("Boas vindas! Você realizou seu registro com sucesso.")

  end
end
