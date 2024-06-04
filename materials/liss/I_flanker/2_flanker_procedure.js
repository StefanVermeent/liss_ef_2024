var flanker_present_arrows = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: function(){
    return jsPsych.timelineVariable('stim')
  },
  choices: ['A', 'L'],
  data: {
    variable: 'test',
    task: 'flanker',
    stimulus: "",
    location: function(){
      return jsPsych.timelineVariable('location')
    },
    stimtype: function(){
      return jsPsych.timelineVariable('stimtype')
    },
    correct_response: function(){
      return jsPsych.timelineVariable('correct_response')
    }
  },
  on_finish: function(data) { {
    if(jsPsych.pluginAPI.compareKeys(data.response, jsPsych.timelineVariable('correct_response', true))) {
      data.correct = true;
    } else {
      data.correct = false;
    }
  }
  }
};


var flanker_test_procedure01 = {
  timeline: [flanker_fixation, flanker_present_arrows],
  timeline_variables: [
    {location: 'top',    correct_response: 'A', stimtype: 'congruent_left',    stim: location_stim(up='&larr;&larr;&larr;&larr;&larr;', down=null)},
    {location: 'top',    correct_response: 'L', stimtype: 'congruent_right',   stim: location_stim(up='&rarr;&rarr;&rarr;&rarr;&rarr;', down=null)},
    {location: 'top',    correct_response: 'A', stimtype: 'incongruent_left',  stim: location_stim(up='&rarr;&rarr;&larr;&rarr;&rarr;', down=null)},
    {location: 'top',    correct_response: 'L', stimtype: 'incongruent_right', stim: location_stim(up='&larr;&larr;&rarr;&larr;&larr;', down=null)},
    {location: 'bottom', correct_response: 'A', stimtype: 'congruent_left',    stim: location_stim(up=null, down='&larr;&larr;&larr;&larr;&larr;')},
    {location: 'bottom', correct_response: 'L', stimtype: 'congruent_right',   stim: location_stim(up=null, down='&rarr;&rarr;&rarr;&rarr;&rarr;')},
    {location: 'bottom', correct_response: 'A', stimtype: 'incongruent_left',  stim: location_stim(up=null, down='&rarr;&rarr;&larr;&rarr;&rarr;')},
    {location: 'bottom', correct_response: 'L', stimtype: 'incongruent_right', stim: location_stim(up=null, down='&larr;&larr;&rarr;&larr;&larr;')},
  ],
  randomize_order: true,
  repetitions: 4,
};

var flanker_interblock = {
  type: jsPsychHtmlButtonResponse,
  stimulus: "Goed gedaan! U bent nu halverwege.<br>Neem even pauze als u dat nodig heeft en druk op 'verder' als u klaar bent voor de rest van het spel.<br><br>",
  choices: ['verder'],
  data: {
    task: 'flanker',
    variable: 'interblock'
  }
}

var flanker_test_start = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: "<p style = 'text-align: center;'>" +
      "Plaats uw vingers op de 'A'-toets en 'L'-toets op uw toetsenbord.<br><br><br>" +
      "Druk op een willekeurige toets als u klaar ben om door te gaan.",
  choices: "ALL_KEYS",
  data: {
    variable: 'test_start', task: 'flanker'
  }
}

var flanker_test_procedure02 = {
  timeline: [flanker_fixation, flanker_present_arrows],
  timeline_variables: [
    {location: 'top',    correct_response: 'A', stimtype: 'congruent_left',    stim: location_stim(up='&larr;&larr;&larr;&larr;&larr;', down=null)},
    {location: 'top',    correct_response: 'L', stimtype: 'congruent_right',   stim: location_stim(up='&rarr;&rarr;&rarr;&rarr;&rarr;', down=null)},
    {location: 'top',    correct_response: 'A', stimtype: 'incongruent_left',  stim: location_stim(up='&rarr;&rarr;&larr;&rarr;&rarr;', down=null)},
    {location: 'top',    correct_response: 'L', stimtype: 'incongruent_right', stim: location_stim(up='&larr;&larr;&rarr;&larr;&larr;', down=null)},
    {location: 'bottom', correct_response: 'A', stimtype: 'congruent_left',    stim: location_stim(up=null, down='&larr;&larr;&larr;&larr;&larr;')},
    {location: 'bottom', correct_response: 'L', stimtype: 'congruent_right',   stim: location_stim(up=null, down='&rarr;&rarr;&rarr;&rarr;&rarr;')},
    {location: 'bottom', correct_response: 'A', stimtype: 'incongruent_left',  stim: location_stim(up=null, down='&rarr;&rarr;&larr;&rarr;&rarr;')},
    {location: 'bottom', correct_response: 'L', stimtype: 'incongruent_right', stim: location_stim(up=null, down='&larr;&larr;&rarr;&larr;&larr;')},
  ],
  randomize_order: true,
  repetitions: 4,
};
