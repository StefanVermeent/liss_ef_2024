var simon_target = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: function(){

    var stim = ""



    if (jsPsych.timelineVariable('location') == 'left'){
      stim += "<div class='grid-container'>" +
                "<div style='font-size: 30px;'>" + jsPsych.timelineVariable('stim') + "</div>" +
                "<div style='font-size: 60px'>+</div>" +
                "<div style='font-size: 30px;'></div>" +
              "</div>"
    }

    if (jsPsych.timelineVariable('location') == 'right'){
      stim += "<div class='grid-container'>" +
                "<div style='font-size: 30px;'></div>" +
                "<div style='font-size: 60px'>+</div>" +
                "<div style='font-size: 30px;'>" + jsPsych.timelineVariable('stim') + "</div>" +
              "</div>"
    }

    return stim
  },
  choices: ['A', 'L'],
  data: {
    variable: 'simon_test',
    task: 'simon',
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


var simon_test_procedure = {
  timeline: [simon_fixation, simon_target],
  timeline_variables: [
    {location: 'left',    correct_response: 'A', stimtype: 'congruent',   stim: "LINKS"},
    {location: 'left',    correct_response: 'L', stimtype: 'incongruent', stim: "RECHTS"},
    {location: 'right',   correct_response: 'A', stimtype: 'congruent',   stim: "RECHTS"},
    {location: 'right',   correct_response: 'L', stimtype: 'incongruent', stim: "LINKS"},
  ],
  randomize_order: true,
  repetitions: 16,
};
