var posner_letters = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: function(){
    var stim = '<p style="font-size:80px;font-weight:bold;">'+jsPsych.timelineVariable('stim1')+jsPsych.timelineVariable('stim2')+'</p>'
    return stim
  },
  choices: ['A', 'L'],
  data: {
    variable: 'posner_test',
    task: 'posner',
    condition: function(){
      return jsPsych.timelineVariable('condition')
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


var posner_test_procedure = {
  timeline: [posner_fixation, posner_letters],
  timeline_variables: [
    {stim1: 'B', stim2: 'q', condition: 'different', correct_response: 'L'},
    {stim1: 'Q', stim2: 'q', condition: 'same',      correct_response: 'A'},
    {stim1: 'A', stim2: 'B', condition: 'different', correct_response: 'L'},
    {stim1: 'q', stim2: 'q', condition: 'same',      correct_response: 'A'},
    {stim1: 'a', stim2: 'H', condition: 'different', correct_response: 'L'},
    {stim1: 'F', stim2: 'H', condition: 'different', correct_response: 'L'},
    {stim1: 'b', stim2: 'f', condition: 'different', correct_response: 'L'},
    {stim1: 'a', stim2: 'A', condition: 'same',      correct_response: 'A'},
    {stim1: 'f', stim2: 'B', condition: 'different', correct_response: 'L'},
    {stim1: 'Q', stim2: 'q', condition: 'same',      correct_response: 'A'},
    {stim1: 'h', stim2: 'a', condition: 'different', correct_response: 'L'},
    {stim1: 'A', stim2: 'q', condition: 'different', correct_response: 'L'},
    {stim1: 'q', stim2: 'a', condition: 'different', correct_response: 'L'},
    {stim1: 'B', stim2: 'b', condition: 'same',      correct_response: 'A'},
    {stim1: 'a', stim2: 'B', condition: 'different', correct_response: 'L'},
    {stim1: 'A', stim2: 'a', condition: 'same',      correct_response: 'A'},
    {stim1: 'f', stim2: 'f', condition: 'same',      correct_response: 'A'},
    {stim1: 'A', stim2: 'f', condition: 'different', correct_response: 'L'},
    {stim1: 'H', stim2: 'h', condition: 'same',      correct_response: 'A'},
    {stim1: 'b', stim2: 'H', condition: 'different', correct_response: 'L'},
    {stim1: 'f', stim2: 'a', condition: 'different', correct_response: 'L'},
    {stim1: 'f', stim2: 'F', condition: 'same',      correct_response: 'A'},
    {stim1: 'h', stim2: 'H', condition: 'same',      correct_response: 'A'},
    {stim1: 'q', stim2: 'q', condition: 'same',      correct_response: 'A'},
    {stim1: 'H', stim2: 'q', condition: 'different', correct_response: 'L'},
    {stim1: 'q', stim2: 'Q', condition: 'same',      correct_response: 'A'},
    {stim1: 'b', stim2: 'B', condition: 'same',      correct_response: 'A'},
    {stim1: 'B', stim2: 'H', condition: 'different', correct_response: 'L'},
    {stim1: 'F', stim2: 'F', condition: 'same',      correct_response: 'A'},
    {stim1: 'q', stim2: 'f', condition: 'different', correct_response: 'L'},
    {stim1: 'Q', stim2: 'Q', condition: 'same',      correct_response: 'A'},
    {stim1: 'h', stim2: 'h', condition: 'same',      correct_response: 'A'},
    {stim1: 'a', stim2: 'q', condition: 'different', correct_response: 'L'},
    {stim1: 'h', stim2: 'q', condition: 'different', correct_response: 'L'},
    {stim1: 'Q', stim2: 'H', condition: 'different', correct_response: 'L'},
    {stim1: 'a', stim2: 'a', condition: 'same',      correct_response: 'A'},
    {stim1: 'F', stim2: 'q', condition: 'different', correct_response: 'L'},
    {stim1: 'q', stim2: 'H', condition: 'different', correct_response: 'L'},
    {stim1: 'h', stim2: 'f', condition: 'different', correct_response: 'L'},
    {stim1: 'a', stim2: 'A', condition: 'same',      correct_response: 'A'},
    {stim1: 'b', stim2: 'b', condition: 'same',      correct_response: 'A'},
    {stim1: 'B', stim2: 'b', condition: 'same',      correct_response: 'A'},
    {stim1: 'F', stim2: 'B', condition: 'different', correct_response: 'L'},
    {stim1: 'H', stim2: 'a', condition: 'different', correct_response: 'L'},
    {stim1: 'H', stim2: 'B', condition: 'different', correct_response: 'L'},
    {stim1: 'H', stim2: 'h', condition: 'same',      correct_response: 'A'},
    {stim1: 'B', stim2: 'a', condition: 'different', correct_response: 'L'},
    {stim1: 'q', stim2: 'Q', condition: 'same',      correct_response: 'A'},
    {stim1: 'A', stim2: 'A', condition: 'same',      correct_response: 'A'},
    {stim1: 'F', stim2: 'a', condition: 'different', correct_response: 'L'},
    {stim1: 'F', stim2: 'f', condition: 'same',      correct_response: 'A'},
    {stim1: 'A', stim2: 'a', condition: 'same',      correct_response: 'A'},
    {stim1: 'q', stim2: 'B', condition: 'different', correct_response: 'L'},
    {stim1: 'Q', stim2: 'Q', condition: 'same',      correct_response: 'A'},
    {stim1: 'B', stim2: 'f', condition: 'different', correct_response: 'L'},
    {stim1: 'A', stim2: 'H', condition: 'different', correct_response: 'L'},
    {stim1: 'B', stim2: 'B', condition: 'same',      correct_response: 'A'},
    {stim1: 'A', stim2: 'A', condition: 'same',      correct_response: 'A'},
    {stim1: 'a', stim2: 'f', condition: 'different', correct_response: 'L'},
    {stim1: 'b', stim2: 'B', condition: 'same',      correct_response: 'A'},
    {stim1: 'f', stim2: 'f', condition: 'same',      correct_response: 'A'},
    {stim1: 'h', stim2: 'h', condition: 'same',      correct_response: 'A'},
    {stim1: 'Q', stim2: 'f', condition: 'different', correct_response: 'L'},
    {stim1: 'f', stim2: 'H', condition: 'different', correct_response: 'L'},
    {stim1: 'H', stim2: 'H', condition: 'same',      correct_response: 'A'},
    {stim1: 'Q', stim2: 'a', condition: 'different', correct_response: 'L'},
    {stim1: 'F', stim2: 'F', condition: 'same',      correct_response: 'A'},
    {stim1: 'Q', stim2: 'B', condition: 'different', correct_response: 'L'},
    {stim1: 'a', stim2: 'a', condition: 'same',      correct_response: 'A'},
    {stim1: 'h', stim2: 'H', condition: 'same',      correct_response: 'A'},
    {stim1: 'f', stim2: 'F', condition: 'same',      correct_response: 'A'},
    {stim1: 'h', stim2: 'B', condition: 'different', correct_response: 'L'},
    {stim1: 'B', stim2: 'B', condition: 'same',      correct_response: 'A'},
    {stim1: 'b', stim2: 'a', condition: 'different', correct_response: 'L'},
    {stim1: 'f', stim2: 'q', condition: 'different', correct_response: 'L'},
    {stim1: 'b', stim2: 'q', condition: 'different', correct_response: 'L'},
    {stim1: 'b', stim2: 'b', condition: 'same',      correct_response: 'A'},
    {stim1: 'H', stim2: 'H', condition: 'same',      correct_response: 'A'},
    {stim1: 'H', stim2: 'f', condition: 'different', correct_response: 'L'},
    {stim1: 'F', stim2: 'f', condition: 'same',      correct_response: 'A'},
  ],
};
