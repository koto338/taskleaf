User.find_or_create_by!(email: 'admi@example.com') do |user|
  name: 'admin',
  email: 'admi@example.com',
  admin: true,
  password: 'password',
  password_confirmation: 'password'
end