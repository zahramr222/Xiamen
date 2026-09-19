class Rack::Attack

  throttle("inquiry/ip", limit: 5, period: 1.minute) do |request|
    request.ip if request.post? && request.path == "/inquiry"
  end


  throttle("contact/ip", limit: 5, period: 1.minute) do |request|
    request.ip if request.post? && request.path == "/contact"
  end


  throttle("newsletter/ip", limit: 5, period: 1.minute) do |request|
    request.ip if request.post? && request.path == "/newsletter"
  end

  throttle("login/ip", limit: 5, period: 1.minute) do |request|
  if request.post? && request.path == "/users/sign_in"
    request.ip
  end
  end

end