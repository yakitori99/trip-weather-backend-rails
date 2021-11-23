json.array! @favorites do |favorite|
  json.extract! favorite, :nickname
end
