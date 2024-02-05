//-------------------- Welcome
var simon_welcome = {
  type: jsPsychInstructions,
  pages: [
    "Welkom bij het <b>Richtingen</b> spel!"
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "verder",
  data: {variable: 'welcome', task: "simon_practice"}
};

//-------------------- Instructions
var simon_instructions = {
  type: jsPsychInstructions,
  pages: [
    "<p style = 'text-align: center;'>"+
      "In dit spel ziet u steeds het woord 'LINKS' of 'RECHTS'.<br><br>" +
      "Als u het woord 'LINKS' ziet, drukt u op de 'A'-toets op uw toetsenbord.<br>" +
      "Als u het woord 'RECHTS' ziet, drukt u op de 'L'-toets op uw toetsenbord.<br>",


     "<p style = 'text-align: center;'>"+
      "Antwoord zo snel als u kunt zonder fouten te maken.<br>Af en toe een fout maken is niet erg. Ga in dat geval gewoon door.<br><br>" +
      "Klik op 'verder' om het spel te oefenen.<br><br><br>"
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "verder",
  button_label_previous: "ga terug",
  data: {variable: "instructions", task: "simon_practice"}
};

//-------------------- Practice

var simon_practice_start = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus:    "<p style = 'text-align: center;'>" +
      "U gaat het spel nu <strong> 8 keer</strong> oefenen.<br><br>" +
      "Plaats uw vingers op de 'A'-toets en 'L'-toets op uw toetsenbord.<br><br>" +
      "Druk op een willekeurige knop als u klaar bent om te oefenen.",
  choices: "ALL_KEYS",
  data: {variable: "practice_start", task: "simon_practice"}
};


var simon_practice = {
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
    variable: 'practice',
    task: 'simon_practice',
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
  on_finish: function(data) {
    if(jsPsych.pluginAPI.compareKeys(data.response, jsPsych.timelineVariable('correct_response', true))) {
      data.correct = true;
    } else {
      data.correct = false;
    }
  }
};


var simon_practice_procedure = {
  timeline: [simon_fixation, simon_practice, feedback],
  timeline_variables: [
    {location: 'left',    correct_response: 'A', stimtype: 'congruent',   stim: "LINKS"},
    {location: 'left',    correct_response: 'L', stimtype: 'incongruent', stim: "RECHTS"},
    {location: 'right',   correct_response: 'L', stimtype: 'congruent',   stim: "RECHTS"},
    {location: 'right',   correct_response: 'A', stimtype: 'incongruent', stim: "LINKS"},
  ],
  randomize_order: true,
  repetitions: 2,
};



// Finish Practice trials
var simon_practice_finish = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: "<p style = 'text-align: center;'>" +
  "Goed gedaan!<br><br>" +
  "U gaat nu het echte spel spelen.<br><br>" +
  "Dit spel duurt ongeveer 2 minuten. Vanaf nu krijgt u geen feedback meer.<br><br>" +
  "Druk op een willekeurige knop om te beginnen! <br><br>",
  choices: "ALL_KEYS",
  data: {variable: "practice_finish", task: "simon_practice"}
};

var simon_end = {
  type: jsPsychHtmlButtonResponse,
  stimulus:
  "Goed gedaan!<br><br>" +
  "U bent nu klaar met het <strong>Richtingen</strong> spel.<br><br>" +
  "Klik op 'verder' om verder te gaan.<br><br>",
  choices: ['verder'],
  data: {variable: "end", task: "simon_practice"}
};
