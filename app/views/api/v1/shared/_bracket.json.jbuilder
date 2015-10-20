json.merge! bracket.attributes.reject{|k,v| /ed_at$/ =~ k}

json.picks do
  json.partial! partial: 'api/v1/shared/pick', collection: bracket.picks,  as: :pick
end
