//-------------------- Welcome
var flanker_welcome = {
  type: jsPsychInstructions,
  pages: [
    "Welkom bij het <b>Pijlen</b> spel!<br><br><br><br>"
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "verder",
  data: {variable: 'welcome', task: "flanker_practice"}
};

//-------------------- Instructions
var flanker_instructions = {
  type: jsPsychInstructions,
  pages: [
    "<p style = 'text-align: center;'>"+
      "In dit spel ziet u steeds vijf pijlen, zoals hieronder:<br><br><br>" +
      "<div style = 'font-size: 50px'>&larr;&larr;&larr;&larr;&larr;</div><br><br><br>" +
      "Uw taak is om de richting van de <strong>MIDDELSTE PIJL</strong> aan te geven.<br><br><br>",

     "<p style = 'text-align: center;'>"+
      "Soms wijzen alle pijlen dezelfde kant op, zoals hieronder:<br><br><br>" +
      "<div style = 'font-size: 50px'>&rarr;&rarr;&rarr;&rarr;&rarr;</div><br><br><br>",

     "<p style = 'text-align: center;'>"+
      "Soms wijzen de pijlen de <strong>andere</strong> kant op, zoals hieronder:<br><br><br>" +
      "<div style = 'font-size: 50px'>&larr;&larr;&rarr;&larr;&larr;</div><br><br><br>",

      "<p style = 'text-align: center;'>"+
      "Uw taak is <i>altijd</i> om de richting van de middelste pijl te bepalen. De andere pijlen moet u <i>altijd</i> negeren.<br><br>" +

      "<div style = 'float: left;'>Als hij naar LINKS wijst<br>Druk dan op de 'A'-toets.</div>" +
      "<div style = 'float: right;'>Als hij naar RECHTS wijst<br>Druk dan op de 'L'-toets.</div><br><br><br><br>" +

      "In het voorbeeld hieronder wijst de middelste pijl naar LINKS.<br>" +
      "In dit geval drukt u dus op de 'A'-toets.<br><br>" +
      "<div style = 'font-size: 50px'>&rarr;&rarr;&larr;&rarr;&rarr;</div></p><br><br><br>",

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
  data: {variable: "instructions", task: "flanker_practice"}
};

//-------------------- Practice

var flanker_practice_start = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus:    "<p style = 'text-align: center;'>" +
      "U gaat het spel nu <strong>8 keer</strong> oefenen.<br><br>" +
      "Plaats uw vingers op de 'A'- en 'L'-toets op uw toetsenbord.<br><br>" +
      "Druk op een willekeurige knop als u klaar bent om te oefenen.",
  choices: "ALL_KEYS",
  data: {variable: "practice_start", task: "flanker_practice"}
};


var flanker_practice = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: function() {
      return jsPsych.timelineVariable('practice_stim')
    },
    choices: ['A', 'L'],
    data: {
      variable: 'practice',
      task: 'flanker_practice',
      location: function(){
        return jsPsych.timelineVariable('location')
      },
      stimtype: function(){
        return jsPsych.timelineVariable('stimtype')
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


var flanker_practice_procedure = {
  timeline: [flanker_fixation, flanker_practice, feedback],
  timeline_variables: [
    {location: 'top',    correct_response: 'A',  stimtype: 'congruent_left',    practice_stim: location_stim(up='&larr;&larr;&larr;&larr;&larr;', down=null)},
    {location: 'top',    correct_response: 'L', stimtype: 'congruent_right',   practice_stim: location_stim(up='&rarr;&rarr;&rarr;&rarr;&rarr;', down=null)},
    {location: 'top',    correct_response: 'A',  stimtype: 'incongruent_left',  practice_stim: location_stim(up='&rarr;&rarr;&larr;&rarr;&rarr;', down=null)},
    {location: 'top',    correct_response: 'L', stimtype: 'incongruent_right', practice_stim: location_stim(up='&larr;&larr;&rarr;&larr;&larr;', down=null)},
    {location: 'bottom', correct_response: 'A',  stimtype: 'congruent_left',    practice_stim: location_stim(up=null, down='&larr;&larr;&larr;&larr;&larr;')},
    {location: 'bottom', correct_response: 'L', stimtype: 'congruent_right',   practice_stim: location_stim(up=null, down='&rarr;&rarr;&rarr;&rarr;&rarr;')},
    {location: 'bottom', correct_response: 'A',  stimtype: 'incongruent_left',  practice_stim: location_stim(up=null, down='&rarr;&rarr;&larr;&rarr;&rarr;')},
    {location: 'bottom', correct_response: 'L', stimtype: 'incongruent_right', practice_stim: location_stim(up=null, down='&larr;&larr;&rarr;&larr;&larr;')},
  ],
  randomize_order: true,
  repetitions: 1,
};



// Finish Practice trials
var flanker_practice_finish = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: "<p style = 'text-align: center;'>" +
  "Goed gedaan!<br><br>" +
  "U gaat nu het echte spel spelen.<br><br>" +
  "Het spel duurt ongeveer twee minuten. Vanaf nu krijgt u geen feedback meer.<br><br>" +
  "Druk op een willekeurige knop om te beginnen! <br><br>",
  choices: "ALL_KEYS",
  data: {variable: "practice_finish", task: "flanker_practice"}
};

var flanker_end = {
  type: jsPsychHtmlButtonResponse,
  stimulus:
  "Goed gedaan!<br><br>" +
  "U bent nu klaar met het <strong>Pijlen</strong> spel.<br><br>" +
  "Klik op 'verder' om verder te gaan.<br><br>",
  choices: ['verder'],
  data: {variable: "end", task: "flanker_practice"}
};
