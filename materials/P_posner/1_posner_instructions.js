//-------------------- Welcome
var posner_welcome = {
  type: jsPsychInstructions,
  pages: [
    "Welkom bij het <b>Vergelijk</b> spel!<br><br><br><br>"
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "verder",
  data: {variable: 'welcome', task: "posner_practice"}
};

//-------------------- Instructions
var posner_instructions = {
  type: jsPsychInstructions,
  pages: [
    "<p style = 'text-align: center;'>"+
      "In dit spel ziet u steeds twee letters naast elkaar<br><br>" +
      "Uw taak is steeds om aan te geven of het <strong>dezelfde</strong> of <strong>verschillende</strong> letters zijn.<br><br>" +
      "Dit is een voorbeeld van twee <i>dezelfde</i> letters: <strong>AA</strong><br>" +
      "Dit is een voorbeeld van twee <i>verschillende</i> letters: <strong>bq</strong><br>",

      "De letters kunnen zowel <i>hoofdletters</i> als <i>kleine letters</i> zijn.<br>" +
      "Dit maakt niet uit voor uw keuze.<br><br>" +
      "<strong>bB</strong> en <strong>bb</strong> zijn allebei voorbeelden van twee <i>dezelfde</i> letters.<br>" +
      "<strong>aq</strong> en <strong>Aq</strong> zijn allebei voorbeelden van twee <i>verschillende</i> letters.<br>",

      "<p style = 'text-align: center;'>"+
      "<div style = 'width: 200px; padding: 20px; float: left;'>Als het dezelfde<br>letters zijn,<br>druk dan op de<br>'A'-toets.<br><br><strong>fF</strong></div>" +
      "<div style = 'width: 200px; padding: 20px; float: right;'>Als het verschillende<br>letters zijn,<br>druk dan op de<br>'L'-toets.<br><br><strong>Qa</strong></div><br><br><br><br>",

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
  data: {variable: "instructions", task: "posner_practice"}
};

//-------------------- Practice

var posner_practice_start = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus:    "<p style = 'text-align: center;'>" +
      "U gaat het spel nu <strong>8 keer</strong> oefenen.<br><br>" +
      "Plaats uw vingers op de 'A'-toets (HETZELFDE) en 'L'-toets (VERSCHILLEND) op uw toetsenbord.<br><br>" +
      "Druk op een willekeurige toets als u klaar bent om te oefenen.",
  choices: "ALL_KEYS",
  data: {variable: "practice_start", task: "posner_practice"}
};


var posner_practice_letters = {
    type: jsPsychHtmlKeyboardResponse,
  stimulus: function(){
    var stim = '<p style="font-size:80px;font-weight:bold;">'+jsPsych.timelineVariable('stim1')+jsPsych.timelineVariable('stim2')+'</p>'
    return stim
  },
  choices: ['A', 'L'],
    data: {
      variable: 'practice',
      task: 'posner_practice',
      condition: function(){
      return jsPsych.timelineVariable('condition')
    },
    correct_response: function(){
      return jsPsych.timelineVariable('correct_response')
    }
    },
    on_finish: function(data) {
      console.log(data.response)
      console.log(jsPsych.timelineVariable('correct_response', true))
      if(jsPsych.pluginAPI.compareKeys(data.response, jsPsych.timelineVariable('correct_response', true))) {
        data.correct = true;
      } else {
        data.correct = false;
      }
    }
};

var posner_practice_procedure = {
  timeline: [posner_fixation, posner_practice_letters, feedback],
  timeline_variables: [
    {stim1: 'Q', stim2: 'q', condition: 'same',      correct_response: 'A'},
    {stim1: 'a', stim2: 'a', condition: 'same',      correct_response: 'A'},
    {stim1: 'h', stim2: 'b', condition: 'different', correct_response: 'L'},
    {stim1: 'B', stim2: 'b', condition: 'same',      correct_response: 'A'},
    {stim1: 'A', stim2: 'F', condition: 'different', correct_response: 'L'},
    {stim1: 'q', stim2: 'B', condition: 'different', correct_response: 'L'},
    {stim1: 'f', stim2: 'f', condition: 'same',      correct_response: 'A'},
    {stim1: 'B', stim2: 'a', condition: 'different', correct_response: 'L'},
  ],
  repetitions: 1,
};



// Finish Practice trials
var posner_practice_finish = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: "<p style = 'text-align: center;'>" +
  "Goed gedaan!<br><br>" +
  "U gaat nu het echte spel spelen.<br><br>" +
  "Het spel duurt ongeveer 2 minuten. Vanaf nu ontvangt u geen feedback meer.<br><br>" +
  "Druk op een willekeurige knop om te beginnen! <br><br>",
  choices: "ALL_KEYS",
  data: {variable: "practice_finish", task: "posner_practice"}
};

var posner_end = {
  type: jsPsychHtmlButtonResponse,
  stimulus:
  "Goed gedaan!<br><br>" +
  "U bent nu klaar met het spelen van het <strong>Vergelijk</strong> spel.<br><br>" +
  "Klik op 'verder' om verder te gaan.<br><br>",
  choices: ['verder'],
  data: {variable: "end", task: "posner"}
};
