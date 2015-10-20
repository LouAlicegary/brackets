########## Document Ready handler #########
$(document).ready ->
    getData()



############ Main function ############
@getData = () ->

    $.ajax
        url: "http://localhost:3000/api/v1/groups/1"
        dataType: "json"
        error: (jqXHR, textStatus, errorThrown) ->
            console.log jqXHR, textStatus, errorThrown
        success: (data, textStatus, jqXHR) ->
            getDataCallback data, textStatus, jqXHR




############# Callback on success of getData. ############
@getDataCallback = (data, textStatus, errorThrown) ->
    storeDataLocally data
 
    #console.log "Incoming data:\n", data

    updateStandings data




############# Store data in local storage ############
@storeDataLocally = (data) ->
    Group.set(data)




############# Bracket info to console ############
@updateStandings = (data) ->

    ranks = []

    $.each data.brackets, (index, bracket) ->
        entry = []
        entry.push bracket.name 
        entry.push Bracket.currentScore bracket
        entry.push Bracket.numberCorrect bracket
        ranks.push entry 
    
    ranks.sort (a, b) -> 
        return b[1]-a[1]

    $.each ranks, (index, entry) ->
        #console.log entry[0], entry[1]
        $("#rank-" + index + "-name").text entry[0]
        $("#rank-" + index + "-current").text entry[1]
        $("#rank-" + index + "-possible").text entry[2]



############ onClick handler for buttons ############
@clickWinner = (this_id, next_id) ->
    

    console.log "CLICK\n", Game.getByHtmlId this_id.slice(0,-2)

    updateWinnerInDom this_id, next_id

    # Updates pick data representation in JS
    updated_data = Group.updateBrackets this_id;
    
    # Gets bracket scores and updates DOM
    updateStandings updated_data

    return




@updateWinnerInDom = (this_id, next_id) ->  

    # Grabbed from DOM - used to populate selections for future rounds
    seed = $('#' + this_id + " .col-lg-2").text()
    team = $('#' + this_id + " .col-lg-9").text()
    
    round = this_id.split("-")[1]

    if round == 6
        alert team + " is the champ!"
    else
        if Game.getByHtmlId(this_id.slice(0,-2)).get_round_placement_for_pick == "top"
            $('#' + next_id + "-1").children().eq(0).children().eq(0).text seed
            $('#' + next_id + "-1").children().eq(0).children().eq(1).text team    
        else
            $('#' + next_id + "-2").children().eq(0).children().eq(0).text seed
            $('#' + next_id + "-2").children().eq(0).children().eq(1).text team  

        

