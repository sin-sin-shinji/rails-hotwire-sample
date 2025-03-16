require 'rails_helper'

RSpec.describe "GET /health_check", type: :system do
  before do
    driven_by :playwright
  end

  it "200を返すこと" do
    visit health_check_path
    expect(page.status_code).to eq(200)
  end
end
