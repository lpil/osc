ignore([/^(_build|deps).*/])

guard :shell do
  watch(/.*\.exs?$/) do
    system 'mix test'
  end
end
