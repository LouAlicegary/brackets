json.merge! @group.attributes.reject{ |key, value| /ed_at$/ =~ key }

json.brackets do
  json.partial! partial: 'api/v1/shared/bracket', collection: @group.brackets,  as: :bracket
end

json.games do
  json.partial! partial: 'api/v1/shared/game', collection: Game.all,  as: :game
end

json.teams do
  json.partial! partial: 'api/v1/shared/team', collection: Team.all,  as: :team
end