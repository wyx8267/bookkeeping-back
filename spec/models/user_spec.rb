require 'rails_helper'

RSpec.describe User, type: :model do
  it '有 email' do
    user = User.new email: 'nekoi@g.com'
    expect(user.email).to eq 'nekoi@g.com'
  end
end
