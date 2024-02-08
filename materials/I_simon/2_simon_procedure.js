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
    variable: 'test',
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


var simon_test_procedure01 = {
  timeline: [simon_fixation, simon_target],
  timeline_variables: [
    {location: 'left', correct_response: 'L', stimtype: 'incongruent', stim: 'RECHTS'},
    {location: 'right', correct_response: 'A', stimtype: 'incongruent', stim: 'LINKS'},
    {location: 'left', correct_response: 'A', stimtype: 'congruent', stim: 'LINKS'},
    {location: 'right', correct_response: 'A', stimtype: 'incongruent', stim: 'LINKS'},
    {location: 'right', correct_response: 'L', stimtype: 'congruent', stim: 'RECHTS'},
    {location: 'left', correct_response: 'L', stimtype: 'incongruent', stim: 'RECHTS'},
    {location: 'left', correct_response: 'L', stimtype: 'incongruent', stim: 'RECHTS'},
    {location: 'right', correct_response: 'A', stimtype: 'incongruent', stim: 'LINKS'},
    {location: 'right', correct_response: 'L', stimtype: 'congruent', stim: 'RECHTS'},
    {location: 'left', correct_response: 'A', stimtype: 'congruent', stim: 'LINKS'},
    {location: 'left', correct_response: 'A', stimtype: 'congruent', stim: 'LINKS'},
    {location: 'left', correct_response: 'L', stimtype: 'incongruent', stim: 'RECHTS'},
    {location: 'right', correct_response: 'L', stimtype: 'congruent', stim: 'RECHTS'},
    {location: 'right', correct_response: 'A', stimtype: 'incongruent', stim: 'LINKS'},
    {location: 'right', correct_response: 'L', stimtype: 'congruent', stim: 'RECHTS'},
    {location: 'left', correct_response: 'L', stimtype: 'incongruent', stim: 'RECHTS'},
    {location: 'left', correct_response: 'A', stimtype: 'congruent', stim: 'LINKS'},
    {location: 'right', correct_response: 'L', stimtype: 'congruent', stim: 'RECHTS'},
    {location: 'left', correct_response: 'L', stimtype: 'incongruent', stim: 'RECHTS'},
    {location: 'right', correct_response: 'A', stimtype: 'incongruent', stim: 'LINKS'},
    {location: 'left', correct_response: 'A', stimtype: 'congruent', stim: 'LINKS'},
    {location: 'left', correct_response: 'L', stimtype: 'incongruent', stim: 'RECHTS'},
    {location: 'right', correct_response: 'L', stimtype: 'congruent', stim: 'RECHTS'},
    {location: 'right', correct_response: 'A', stimtype: 'incongruent', stim: 'LINKS'},
    {location: 'left', correct_response: 'A', stimtype: 'congruent', stim: 'LINKS'},
    {location: 'right', correct_response: 'A', stimtype: 'incongruent', stim: 'LINKS'},
    {location: 'right', correct_response: 'L', stimtype: 'congruent', stim: 'RECHTS'},
    {location: 'left', correct_response: 'A', stimtype: 'congruent', stim: 'LINKS'},
    {location: 'right', correct_response: 'A', stimtype: 'incongruent', stim: 'LINKS'},
    {location: 'right', correct_response: 'A', stimtype: 'incongruent', stim: 'LINKS'},
    {location: 'right', correct_response: 'L', stimtype: 'congruent', stim: 'RECHTS'},
    {location: 'right', correct_response: 'L', stimtype: 'congruent', stim: 'RECHTS'},
    ]
};

var simon_interblock = {
  type: jsPsychHtmlButtonResponse,
  stimulus: "Goed gedaan! U bent nu halverwege.<br>Neem even pauze als u dat nodig heeft en druk op 'verder' als u klaar bent voor de rest van het spel.<br><br>",
  choices: ['verder'],
  data: {
    task: 'simon',
    variable: 'interblock'
  }
}

var simon_test_start = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: "<p style = 'text-align: center;'>" +
      "Plaats uw vingers op de 'A'-toets en 'L'-toets op uw toetsenbord.<br><br><br>" +
      "Druk op een willekeurige toets als u klaar ben om door te gaan.",
  choices: "ALL_KEYS",
  data: {
    variable: 'test_start', task: 'simon'
  }
}

var simon_test_procedure02 = {
  timeline: [simon_fixation, simon_target],
  timeline_variables: [
    {location: 'left', correct_response: 'A', stimtype: 'congruent', stim: 'LINKS'},
    {location: 'left', correct_response: 'L', stimtype: 'incongruent', stim: 'RECHTS'},
    {location: 'right', correct_response: 'L', stimtype: 'congruent', stim: 'RECHTS'},
    {location: 'right', correct_response: 'L', stimtype: 'congruent', stim: 'RECHTS'},
    {location: 'right', correct_response: 'A', stimtype: 'incongruent', stim: 'LINKS'},
    {location: 'left', correct_response: 'A', stimtype: 'congruent', stim: 'LINKS'},
    {location: 'left', correct_response: 'L', stimtype: 'incongruent', stim: 'RECHTS'},
    {location: 'right', correct_response: 'A', stimtype: 'incongruent', stim: 'LINKS'},
    {location: 'right', correct_response: 'A', stimtype: 'incongruent', stim: 'LINKS'},
    {location: 'left', correct_response: 'A', stimtype: 'congruent', stim: 'LINKS'},
    {location: 'left', correct_response: 'L', stimtype: 'incongruent', stim: 'RECHTS'},
    {location: 'right', correct_response: 'A', stimtype: 'incongruent', stim: 'LINKS'},
    {location: 'right', correct_response: 'L', stimtype: 'congruent', stim: 'RECHTS'},
    {location: 'left', correct_response: 'L', stimtype: 'incongruent', stim: 'RECHTS'},
    {location: 'left', correct_response: 'A', stimtype: 'congruent', stim: 'LINKS'},
    {location: 'right', correct_response: 'L', stimtype: 'congruent', stim: 'RECHTS'},
    {location: 'left', correct_response: 'L', stimtype: 'incongruent', stim: 'RECHTS'},
    {location: 'left', correct_response: 'A', stimtype: 'congruent', stim: 'LINKS'},
    {location: 'right', correct_response: 'L', stimtype: 'congruent', stim: 'RECHTS'},
    {location: 'left', correct_response: 'A', stimtype: 'congruent', stim: 'LINKS'},
    {location: 'left', correct_response: 'L', stimtype: 'incongruent', stim: 'RECHTS'},
    {location: 'right', correct_response: 'L', stimtype: 'congruent', stim: 'RECHTS'},
    {location: 'right', correct_response: 'A', stimtype: 'incongruent', stim: 'LINKS'},
    {location: 'left', correct_response: 'A', stimtype: 'congruent', stim: 'LINKS'},
    {location: 'right', correct_response: 'A', stimtype: 'incongruent', stim: 'LINKS'},
    {location: 'left', correct_response: 'L', stimtype: 'incongruent', stim: 'RECHTS'},
    {location: 'right', correct_response: 'L', stimtype: 'congruent', stim: 'RECHTS'},
    {location: 'left', correct_response: 'L', stimtype: 'incongruent', stim: 'RECHTS'},
    {location: 'left', correct_response: 'A', stimtype: 'congruent', stim: 'LINKS'},
    {location: 'left', correct_response: 'L', stimtype: 'incongruent', stim: 'RECHTS'},
    {location: 'left', correct_response: 'A', stimtype: 'congruent', stim: 'LINKS'},
    {location: 'right', correct_response: 'A', stimtype: 'incongruent', stim: 'LINKS'},
  ]
}

var simon_pp_feedback = {
  type: jsPsychSurveyText,
  questions: [
    {prompt: 'Heb je feedback op dit spel (bijvoorbeeld: duidelijkheid van de instructies; moeilijkheidsgraad; iets wat niet goed leek te werken)?<br>We zouden het op prijs stellen als je het ons hieronder laat weten!', name: 'user_feedback', rows:5, required: false},
  ],
  data: {
    variable: "pp_feedback",
    task: "simon_feedback"
  }
}
