class User::Session
  include FakeActiveRecord::ForForm
  has_fake_attr :account, :password
end