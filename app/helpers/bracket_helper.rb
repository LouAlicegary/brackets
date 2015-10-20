module BracketHelper

  def build_onclick index, html_id, html_id_next
    "clickWinner('#{html_id.to_s}-#{index}', '#{html_id_next}');"
  end


end
